class OAuthSuccessPage {
  OAuthSuccessPage._();

  static const String html = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Successful</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background: #000000;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        
        .container {
            background: #ffffff;
            border-radius: 20px;
            padding: 60px 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            text-align: center;
            max-width: 500px;
            width: 100%;
            animation: slideUp 0.5s ease-out;
        }
        
        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .success-icon {
            width: 80px;
            height: 80px;
            margin: 0 auto 30px;
            background: #000000;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            animation: scaleIn 0.5s ease-out 0.2s both;
        }
        
        @keyframes scaleIn {
            from {
                transform: scale(0);
            }
            to {
                transform: scale(1);
            }
        }
        
        .checkmark {
            width: 40px;
            height: 40px;
            stroke: #ffffff;
            stroke-width: 4;
            stroke-linecap: round;
            stroke-linejoin: round;
            fill: none;
        }
        
        h1 {
            font-size: 28px;
            color: #000000;
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        p {
            font-size: 16px;
            color: #333333;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        
        .close-hint {
            font-size: 14px;
            color: #666666;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="success-icon">
            <svg class="checkmark" viewBox="0 0 24 24">
                <path d="M5 13l4 4L19 7" />
            </svg>
        </div>
        <h1>Login Successful!</h1>
        <p>You have successfully logged in. You can now close this window and return to the application.</p>
        <div class="close-hint">This window can be safely closed</div>
    </div>
</body>
</html>
''';
}
