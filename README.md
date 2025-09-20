# health_care

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

### Environment Setup

Before running the application, you need to set up your environment variables:

1. Copy the `.env.example` file to `.env`:
   ```bash
   cp .env.example .env
   ```

2. Edit the `.env` file and replace `your_openai_api_key_here` with your actual OpenAI API key:
   ```
   OPENAI_API_KEY=your_actual_api_key_here
   ```

3. Get your OpenAI API key from: [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)

### Security Notice

- **Never commit your `.env` file to version control**
- The `.env` file is already added to `.gitignore` for security
- Always use environment variables for sensitive configuration
- Regularly rotate your API keys for better security

## Development

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
