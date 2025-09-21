# Patient Side Implementation - Ambulance Dispatch System

## Overview
This implementation provides a complete patient-side interface for the ambulance dispatch system based on the API documentation. The system integrates with a Flask backend running on `localhost:8080` and provides real-time communication through WebSocket connections.

## Architecture

### Core Components

#### 1. **Data Models** (`lib/models/patient_model.dart`)
- `Location` - Geographic coordinates (lat, lng)
- `Patient` - Patient information and registration data
- `EmergencyType` - Enumeration of emergency types with display names
- `EmergencyRequest` - Emergency request details and status
- `Driver` - Ambulance driver information
- `PatientStatus` - Current patient status and assigned resources

#### 2. **Services**

##### **PatientService** (`lib/services/patient_service.dart`)
- **Patient Registration**: Register with dispatch system
- **Emergency Requests**: Create emergency requests with location and type
- **Status Checking**: Get current patient status from API
- **Location Management**: Helper methods for current location

##### **SocketService** (`lib/services/socket_service.dart`)
- **Real-time Communication**: WebSocket connection to Flask backend
- **Event Handling**: Driver assigned, location updates, ambulance arrived
- **Connection Management**: Auto-reconnection and status monitoring

#### 3. **State Management**

##### **PatientProvider** (`lib/providers/patient_provider.dart`)
- **Patient State**: Registration, emergency request, and tracking states
- **Real-time Updates**: Integration with WebSocket for live data
- **Error Handling**: Comprehensive error management and user feedback

#### 4. **User Interface**

##### **Emergency Type Selector** (`lib/widgets/emergency_type_selector.dart`)
- **Type Selection**: Visual grid of emergency types
- **Integration**: Direct integration with PatientProvider
- **User Experience**: Clear icons, descriptions, and status feedback

##### **Enhanced Map Screen** (`lib/screens/map_screen.dart`)
- **Real-time Tracking**: Shows actual ambulance location from WebSocket
- **Status Panel**: Dynamic status display based on emergency state
- **Backwards Compatibility**: Fallback to simulation for testing

##### **Patient Status Screen** (`lib/screens/patient_status_screen.dart`)
- **Comprehensive Dashboard**: Complete patient information and status
- **Real-time Updates**: Live connection status and emergency details
- **Action Buttons**: Quick access to map view and emergency requests

## API Integration

### Endpoints Used
- `POST /api/patient/register` - Patient registration
- `POST /api/patient/emergency` - Emergency request creation
- `GET /api/patient/status/{patient_id}` - Patient status retrieval
- `GET /api/system/status` - System health check

### WebSocket Events
- **Outgoing**: `register_patient`, `emergency_request`, `update_location`
- **Incoming**: `driver_assigned`, `driver_location_update`, `ambulance_arrived`

## Key Features

### 1. **Emergency Request Flow**
1. User presses emergency button
2. Emergency type selector appears
3. Patient registration (if needed)
4. Emergency request sent to API
5. WebSocket connection for real-time updates
6. Driver assignment and tracking
7. Live ambulance location updates

### 2. **Real-time Tracking**
- **WebSocket Connection**: Persistent connection to dispatch system
- **Location Updates**: Real-time ambulance position on map
- **Status Changes**: Live updates of emergency progress
- **ETA Calculations**: Dynamic arrival time estimates

### 3. **State Management**
- **Patient States**: 
  - `idle` → `registering` → `registered`
  - `requestingEmergency` → `emergencyRequested` → `driverAssigned`
  - `ambulanceEnRoute` → `ambulanceArrived` → `emergencyCompleted`
- **Error Handling**: Comprehensive error states and recovery
- **Offline Support**: Graceful handling of connection issues

### 4. **Emergency Types**
- **Cardiac Emergency** - Heart-related issues
- **Trauma/Injury** - Physical injuries
- **Breathing Problems** - Respiratory distress
- **Neurological Issues** - Brain/nervous system
- **Accident** - Vehicle or workplace accidents
- **Burns** - Fire or chemical burns
- **Poisoning** - Toxic substance exposure
- **Severe Bleeding** - Heavy blood loss
- **Fall/Fracture** - Bone injuries from falls
- **Other Emergency** - General emergencies

## Usage Instructions

### Setting Up the Backend
1. Ensure Flask backend is running on `localhost:8080`
2. WebSocket server should be available at `ws://localhost:8080`
3. All API endpoints should be accessible

### Running the Application
1. Install dependencies: `flutter pub get`
2. Start the app: `flutter run`
3. The app automatically connects to WebSocket on startup

### Making Emergency Requests
1. **Press Emergency Button**: Red floating action button in center
2. **Select Emergency Type**: Choose from visual grid
3. **Automatic Registration**: App registers patient if needed
4. **Track Ambulance**: View real-time location on map
5. **Status Updates**: Check patient status screen for details

### Monitoring Status
- **Map Screen**: Shows ambulance location and status panel
- **Patient Status Screen**: Detailed dashboard (accessible via navigation)
- **Connection Status**: Real-time WebSocket connection indicator

## Configuration

### API Configuration (`lib/utils/api_config.dart`)
```dart
static const String baseUrl = 'http://localhost:8080';
static const String webSocketUrl = 'ws://localhost:8080';
```

### Dependencies Added
```yaml
socket_io_client: ^2.0.3+1  # WebSocket communication
uuid: ^4.1.0                # Unique ID generation
```

## Error Handling

### Connection Issues
- **WebSocket Reconnection**: Automatic retry on connection loss
- **API Fallbacks**: Graceful degradation when API unavailable
- **User Feedback**: Clear error messages and retry options

### Location Services
- **Permission Handling**: Automatic location permission requests
- **Accuracy Settings**: High accuracy for emergency situations
- **Error Recovery**: Fallback to manual location entry if needed

## Testing

### Local Testing
1. **Mock Backend**: Use existing simulation for testing UI
2. **WebSocket Testing**: Can test with WebSocket test servers
3. **Location Testing**: Use device location or simulator coordinates

### Integration Testing
1. **Start Flask Backend**: Ensure API server is running
2. **Test Registration**: Verify patient registration works
3. **Test Emergency Flow**: Complete emergency request process
4. **Test Real-time Updates**: Verify WebSocket communication

## Future Enhancements

### Planned Features
1. **Push Notifications**: Native mobile notifications
2. **Medical History**: Patient medical information sharing
3. **Voice Commands**: Voice-activated emergency requests
4. **Offline Mode**: Local emergency protocols when offline
5. **Multi-language**: Enhanced localization support

### Integration Opportunities
1. **Hospital Systems**: Electronic health record integration
2. **Insurance**: Insurance verification and billing
3. **Government**: Integration with emergency services database
4. **Analytics**: Emergency response time analytics

## Security Considerations

### Data Protection
- **Location Privacy**: Secure transmission of location data
- **Patient Information**: HIPAA-compliant data handling
- **API Security**: Encrypted communication with backend

### Authentication
- **Patient Verification**: Secure patient identification
- **API Keys**: Proper API key management
- **Session Management**: Secure WebSocket sessions

---

## Quick Start Checklist

- [ ] Flask backend running on `localhost:8080`
- [ ] WebSocket server accessible
- [ ] Flutter dependencies installed (`flutter pub get`)
- [ ] Location permissions granted
- [ ] Emergency button tested
- [ ] Real-time tracking verified

The patient side implementation is now complete and ready for integration with the ambulance dispatch system!