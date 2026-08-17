#include "desktop_updater_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>
#include <VersionHelpers.h>
#include <Shlwapi.h>   // PathFileExistsW
#include <shellapi.h>  // ShellExecuteExW (runas / elevation)

#pragma comment(lib, "Version.lib")
#pragma comment(lib, "Shlwapi.lib")
#pragma comment(lib, "Shell32.lib")

#include <flutter/encodable_value.h>
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>
#include <filesystem>
#include <iostream>
#include <fstream>
#include <cstdlib>
#include <vector>

namespace fs = std::filesystem;
namespace desktop_updater
{

  // static
  void DesktopUpdaterPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarWindows *registrar)
  {
    auto channel =
        std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
            registrar->messenger(), "desktop_updater",
            &flutter::StandardMethodCodec::GetInstance());

    auto plugin = std::make_unique<DesktopUpdaterPlugin>();

    channel->SetMethodCallHandler(
        [plugin_pointer = plugin.get()](const auto &call, auto result)
        {
          plugin_pointer->HandleMethodCall(call, std::move(result));
        });

    registrar->AddPlugin(std::move(plugin));
  }

  DesktopUpdaterPlugin::DesktopUpdaterPlugin() {}

  DesktopUpdaterPlugin::~DesktopUpdaterPlugin() {}

  void createBatFile(const std::wstring &batFilePath,
                     const std::wstring &updateDir,
                     const std::wstring &destDir,
                     const wchar_t *executable_path,
                     const std::string *preElevatedCommand = nullptr)
  {
    // Convert wide strings to regular strings using Windows API for proper conversion
    int updateSize = WideCharToMultiByte(CP_UTF8, 0, updateDir.c_str(), -1, NULL, 0, NULL, NULL);
    std::string updateDirStr(updateSize, 0);
    WideCharToMultiByte(CP_UTF8, 0, updateDir.c_str(), -1, &updateDirStr[0], updateSize, NULL, NULL);
    updateDirStr.pop_back(); // Remove null terminator

    int destSize = WideCharToMultiByte(CP_UTF8, 0, destDir.c_str(), -1, NULL, 0, NULL, NULL);
    std::string destDirStr(destSize, 0);
    WideCharToMultiByte(CP_UTF8, 0, destDir.c_str(), -1, &destDirStr[0], destSize, NULL, NULL);
    destDirStr.pop_back(); // Remove null terminator

    int exePathSize = WideCharToMultiByte(CP_UTF8, 0, executable_path, -1, NULL, 0, NULL, NULL);
    std::string exePathStr(exePathSize, 0);
    WideCharToMultiByte(CP_UTF8, 0, executable_path, -1, &exePathStr[0], exePathSize, NULL, NULL);
    exePathStr.pop_back(); // Remove null terminator

    std::string batScript =
        "@echo off\n"
        "chcp 65001 > NUL\n"
        "timeout /t 4 /nobreak > NUL\n";
    if (preElevatedCommand && !preElevatedCommand->empty())
    {
      batScript += *preElevatedCommand;
      batScript += "\n";
    }
    batScript +=
        "xcopy /E /I /Y \"" +
        updateDirStr + "\\*\" \"" + destDirStr + "\\\"\n"
        "rmdir /S /Q \"" +
        updateDirStr + "\"\n"
        "timeout /t 3 /nobreak > NUL\n"
        "start \"\" \"" +
        exePathStr + "\"\n"
        "timeout /t 2 /nobreak > NUL\n"
        "exit\n";

    std::string batPathNarrow = fs::path(batFilePath).string();
    std::ofstream batFile(batPathNarrow);
    batFile << batScript;
    batFile.close();
    std::cout << "Temporary .bat created.\n";
  }

  void runBatFileWithElevation(const std::wstring &batFilePath, const std::wstring &workingDir)
  {
    WCHAR comSpec[MAX_PATH];
    if (GetEnvironmentVariableW(L"ComSpec", comSpec, MAX_PATH) == 0)
    {
      wcscpy_s(comSpec, L"C:\\Windows\\System32\\cmd.exe");
    }

    std::wstring params = L"/c \"";
    params += batFilePath;
    params += L"\"";

    SHELLEXECUTEINFOW sei = {sizeof(sei)};
    sei.lpVerb = L"runas";
    sei.lpFile = comSpec;
    sei.lpParameters = params.c_str();
    sei.lpDirectory = workingDir.c_str();
    sei.nShow = SW_HIDE;
    sei.fMask = SEE_MASK_NOCLOSEPROCESS;

    if (ShellExecuteExW(&sei))
    {
      if (sei.hProcess)
      {
        CloseHandle(sei.hProcess);
      }
    }
    else
    {
      std::cout << "Failed to run the .bat file with elevation (runas).\n";
    }
  }

  void RestartApp(const std::wstring &updateDir,
                  const std::string *preElevatedCommand = nullptr)
  {
    printf("Restarting the application...\n");

    wchar_t executable_path[MAX_PATH];
    GetModuleFileNameW(NULL, executable_path, MAX_PATH);
    printf("Executable path: %ls\n", executable_path);

    std::wstring exePath(executable_path);
    size_t lastSlash = exePath.find_last_of(L"\\/");
    std::wstring appDir = (lastSlash != std::wstring::npos) ? exePath.substr(0, lastSlash) : L".";

    wchar_t tempPath[MAX_PATH];
    if (GetTempPathW(MAX_PATH, tempPath) == 0)
    {
      std::cout << "Failed to get temp path.\n";
      ExitProcess(1);
    }
    std::wstring batFilePath = std::wstring(tempPath) + L"update_script.bat";

    std::wstring destDir = appDir;

    createBatFile(batFilePath, updateDir, destDir, executable_path, preElevatedCommand);

    runBatFileWithElevation(batFilePath, appDir);

    ExitProcess(0);
  }

  void DesktopUpdaterPlugin::HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result)
  {
    if (method_call.method_name().compare("getPlatformVersion") == 0)
    {
      std::ostringstream version_stream;
      version_stream << "Windows ";
      if (IsWindows10OrGreater())
      {
        version_stream << "10+";
      }
      else if (IsWindows8OrGreater())
      {
        version_stream << "8";
      }
      else if (IsWindows7OrGreater())
      {
        version_stream << "7";
      }
      result->Success(flutter::EncodableValue(version_stream.str()));
    }
    else if (method_call.method_name().compare("restartApp") == 0)
    {
      const flutter::EncodableValue *args = method_call.arguments();
      if (!args)
      {
        result->Error("InvalidArguments", "restartApp requires updateDirectory");
        return;
      }
      std::wstring updateDir;
      std::unique_ptr<std::string> preElevatedCommand;
      try
      {
        const auto &map = std::get<flutter::EncodableMap>(*args);
        auto it = map.find(flutter::EncodableValue("updateDirectory"));
        if (it == map.end())
        {
          result->Error("InvalidArguments", "restartApp requires updateDirectory");
          return;
        }
        const std::string &pathUtf8 = std::get<std::string>(it->second);
        int wideLen = MultiByteToWideChar(CP_UTF8, 0, pathUtf8.c_str(), -1, nullptr, 0);
        if (wideLen <= 0)
        {
          result->Error("InvalidArguments", "updateDirectory is not valid UTF-8");
          return;
        }
        std::vector<wchar_t> buf(wideLen, 0);
        MultiByteToWideChar(CP_UTF8, 0, pathUtf8.c_str(), -1, buf.data(), wideLen);
        updateDir = buf.data();

        auto itPre = map.find(flutter::EncodableValue("preElevatedCommand"));
        if (itPre != map.end())
        {
          const std::string *cmd = std::get_if<std::string>(&itPre->second);
          if (cmd && !cmd->empty())
          {
            preElevatedCommand = std::make_unique<std::string>(*cmd);
          }
          else
          {
            const std::vector<uint8_t> *vec = std::get_if<std::vector<uint8_t>>(&itPre->second);
            if (vec && !vec->empty())
            {
              preElevatedCommand = std::make_unique<std::string>(vec->begin(), vec->end());
            }
          }
        }
      }
      catch (const std::bad_variant_access &)
      {
        result->Error("InvalidArguments", "restartApp expects a map with updateDirectory");
        return;
      }
      RestartApp(updateDir, preElevatedCommand.get());
      result->Success();
    }
    else if (method_call.method_name().compare("getExecutablePath") == 0)
    {
      wchar_t executable_path[MAX_PATH];
      GetModuleFileNameW(NULL, executable_path, MAX_PATH);

      // Convert wchar_t to std::string (UTF-8)
      int size_needed = WideCharToMultiByte(CP_UTF8, 0, executable_path, -1, NULL, 0, NULL, NULL);
      std::string executablePathStr(size_needed, 0);
      WideCharToMultiByte(CP_UTF8, 0, executable_path, -1, &executablePathStr[0], size_needed, NULL, NULL);

      result->Success(flutter::EncodableValue(executablePathStr));
    }
    else if (method_call.method_name().compare("getCurrentVersion") == 0)
    {
      // Get only bundle version, Product version 1.0.0+2, should return 2
      wchar_t exePath[MAX_PATH];
      GetModuleFileNameW(NULL, exePath, MAX_PATH);

      DWORD verHandle = 0;
      UINT size = 0;
      LPBYTE lpBuffer = NULL;
      DWORD verSize = GetFileVersionInfoSizeW(exePath, &verHandle);
      if (verSize == NULL)
      {
        result->Error("VersionError", "Unable to get version size.");
        return;
      }

      std::vector<BYTE> verData(verSize);
      if (!GetFileVersionInfoW(exePath, verHandle, verSize, verData.data()))
      {
        result->Error("VersionError", "Unable to get version info.");
        return;
      }

      // Retrieve translation information
      struct LANGANDCODEPAGE
      {
        WORD wLanguage;
        WORD wCodePage;
      } *lpTranslate;

      UINT cbTranslate = 0;
      if (!VerQueryValueW(verData.data(), L"\\VarFileInfo\\Translation",
                          (LPVOID *)&lpTranslate, &cbTranslate) ||
          cbTranslate < sizeof(LANGANDCODEPAGE))
      {
        result->Error("VersionError", "Unable to get translation info.");
        return;
      }

      // Build the query string using the first translation
      wchar_t subBlock[50];
      swprintf(subBlock, 50, L"\\StringFileInfo\\%04x%04x\\ProductVersion",
               lpTranslate[0].wLanguage, lpTranslate[0].wCodePage);

      if (!VerQueryValueW(verData.data(), subBlock, (LPVOID *)&lpBuffer, &size))
      {
        result->Error("VersionError", "Unable to query version value.");
        return;
      }

      std::wstring productVersion((wchar_t *)lpBuffer);
      size_t plusPos = productVersion.find(L'+');
      if (plusPos != std::wstring::npos && plusPos + 1 < productVersion.length())
      {
        std::wstring buildNumber = productVersion.substr(plusPos + 1);

        // Trim any trailing spaces
        buildNumber.erase(buildNumber.find_last_not_of(L' ') + 1);

        // Convert wchar_t to std::string (UTF-8)
        int size_needed = WideCharToMultiByte(CP_UTF8, 0, buildNumber.c_str(), -1, NULL, 0, NULL, NULL);
        std::string buildNumberStr(size_needed - 1, 0); // Exclude null terminator
        WideCharToMultiByte(CP_UTF8, 0, buildNumber.c_str(), -1, &buildNumberStr[0], size_needed - 1, NULL, NULL);

        result->Success(flutter::EncodableValue(buildNumberStr));
      }
      else
      {
        result->Error("VersionError", "Invalid version format.");
      }
    }
    else
    {
      result->NotImplemented();
    }
  }

} // namespace desktop_updater
