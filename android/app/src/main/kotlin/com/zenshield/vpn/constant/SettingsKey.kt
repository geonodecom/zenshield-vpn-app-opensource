package com.zenshield.vpn.constant

object SettingsKey {
    private const val KEY_PREFIX = "flutter."
    const val CONFIG_PATH = "${KEY_PREFIX}config_path"
    const val IS_PAID = "${KEY_PREFIX}is_paid"
    const val VPN_TIMEOUT = "${KEY_PREFIX}vpn_timeout"
    const val BASE_PATH = "${KEY_PREFIX}base_path"
    const val WORK_PATH = "${KEY_PREFIX}work_path"
    const val TEMP_PATH = "${KEY_PREFIX}temp_path"
    const val PER_APP_PROXY_MODE = "${KEY_PREFIX}perAppProxyMode"
    const val PER_APP_PROXY_EXCLUDE_LIST = "${KEY_PREFIX}perAppProxyExcludeList"
    const val PER_APP_PROXY_INCLUDE_LIST = "${KEY_PREFIX}perAppProxyIncludeList"
    const val DISABLE_MEMORY_LIMIT = "${KEY_PREFIX}disable_memory_limit"
    const val IS_SMART_MODE_ENABLED = "${KEY_PREFIX}isSmartModeEnabled"
    const val VPN_RESTORE_ON_BOOT = "${KEY_PREFIX}vpn_restore_on_boot"
}
