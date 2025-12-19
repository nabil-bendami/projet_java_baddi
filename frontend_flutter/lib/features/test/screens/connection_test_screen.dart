import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/primary_button.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  final ApiClient _apiClient = ApiClient();
  String _connectionStatus = 'Not tested';
  bool _isTesting = false;
  String _responseData = '';
  String _errorMessage = '';

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _connectionStatus = 'Testing...';
      _responseData = '';
      _errorMessage = '';
    });

    try {
      final isConnected = await _apiClient.testConnection();

      setState(() {
        _isTesting = false;
        _connectionStatus = isConnected ? '✅ SUCCESS' : '❌ FAILED';
        _responseData = isConnected
            ? 'Backend is responding correctly!'
            : 'Connection failed';
      });
    } catch (e) {
      setState(() {
        _isTesting = false;
        _connectionStatus = '❌ ERROR';
        _errorMessage = e.toString();
        _responseData = 'Failed to connect to backend';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Backend Connection Test',
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Flutter ↔ Spring Boot Connection Test',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Testing connection to: ${ApiClient.baseUrl}/api/health',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Status Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Connection Status:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _connectionStatus,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _connectionStatus.contains('SUCCESS')
                            ? Colors.green
                            : _connectionStatus.contains('ERROR') ||
                                  _connectionStatus.contains('FAILED')
                            ? Colors.red
                            : Colors.orange,
                      ),
                    ),
                    if (_responseData.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Response:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _responseData,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ],
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Error Details:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _errorMessage,
                        style: const TextStyle(fontSize: 12, color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Test Button
            Center(
              child: PrimaryButton(
                text: _isTesting ? 'Testing...' : 'Test Connection',
                onPressed: _isTesting ? null : _testConnection,
                isLoading: _isTesting,
              ),
            ),

            const SizedBox(height: 24),

            // Configuration Info
            const Text(
              'Configuration Details:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConfigRow('Backend URL', ApiClient.baseUrl),
                    _buildConfigRow('Endpoint', '/api/health'),
                    _buildConfigRow('Method', 'GET'),
                    _buildConfigRow('Expected Response', '"OK"'),
                    _buildConfigRow('CORS', 'Enabled for 10.0.2.2'),
                    _buildConfigRow('Security', 'Public endpoint'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Instructions
            const Text(
              'Instructions:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Ensure Spring Boot backend is running on localhost:8080\n'
              '2. Click "Test Connection" button\n'
              '3. Check if status shows "SUCCESS"\n'
              '4. If failed, check backend logs and network configuration',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }
}
