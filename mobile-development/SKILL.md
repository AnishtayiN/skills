---
name: mobile-development
description: >-
  Build cross-platform and native mobile applications using React Native, Flutter, or native iOS/Android.
  Use this skill when the user mentions mobile app, mobile development, React Native, Flutter,
  iOS development, Android development, cross-platform, mobile UI, mobile navigation,
  push notifications, app store, mobile testing, offline support, mobile performance,
  or says توسعه موبایل، اپلیکیشن موبایل، ری‌اکت نیتیو، فلاتر، توسعه iOS، توسعه Android.
---

# Mobile Development Skill — React Native, Flutter & Native App Development

## Overview

This skill covers mobile application development across React Native, Flutter, and native platforms (iOS/Android). It provides patterns for mobile-specific challenges: navigation, offline support, push notifications, app store deployment, performance optimization, and platform-specific code. Whether building a simple app or a complex enterprise solution, this skill provides the architecture and patterns needed.

## When to Use This Skill

- User wants to build a mobile app
- User asks about React Native, Flutter, or native development
- User needs mobile-specific patterns (navigation, gestures, animations)
- User mentions app store, push notifications, or mobile testing
- User wants to optimize mobile app performance
- User mentions توسعه موبایل, اپلیکیشن موبایل, or ری‌اکت نیتیو

---

## Part 1: Framework Selection

### Comparison Matrix

| Factor | React Native | Flutter | Native (iOS/Android) |
|--------|-------------|---------|---------------------|
| **Language** | JavaScript/TypeScript | Dart | Swift/Kotlin |
| **Performance** | Good (bridge) | Excellent (compiled) | Best |
| **UI Consistency** | Platform-specific | Custom rendering | Platform-native |
| **Development Speed** | Fast | Fast | Slow (2 codebases) |
| **Ecosystem** | Large (npm) | Growing (pub.dev) | Mature (CocoaPods/Gradle) |
| **Hot Reload** | ✅ Fast | ✅ Excellent | ⚠️ Limited |
| **Learning Curve** | Low (if know React) | Medium | High (2 languages) |
| **Best For** | Most apps | Beautiful UI, animations | Performance-critical |

### Decision Guide

```
Is performance critical (games, video editing)?
├── YES → Native (Swift/Kotlin)
└── NO → Do you want platform-native look?
    ├── YES → React Native
    └── NO → Do you want custom UI/animations?
        ├── YES → Flutter
        └── NO → React Native (simpler)
```

---

## Part 2: React Native Patterns

### Project Structure

```
src/
├── components/          # Reusable UI components
│   ├── Button/
│   │   ├── Button.tsx
│   │   ├── Button.test.tsx
│   │   └── index.ts
│   └── index.ts
├── screens/             # Screen components
│   ├── HomeScreen.tsx
│   ├── ProfileScreen.tsx
│   └── SettingsScreen.tsx
├── navigation/          # Navigation configuration
│   ├── AppNavigator.tsx
│   └── types.ts
├── hooks/               # Custom hooks
│   ├── useAuth.ts
│   └── useApi.ts
├── services/            # API calls, storage
│   ├── api.ts
│   └── storage.ts
├── store/               # State management
│   ├── index.ts
│   └── slices/
├── types/               # TypeScript types
│   └── index.ts
└── utils/               # Helper functions
```

### Navigation (React Navigation)

```tsx
import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';

type RootStackParamList = {
  Home: undefined;
  Profile: { userId: string };
  Settings: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();
const Tab = createBottomTabNavigator();

function HomeTabs() {
  return (
    <Tab.Navigator>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
      <Tab.Screen name="Settings" component={SettingsScreen} />
    </Tab.Navigator>
  );
}

export default function AppNavigator() {
  return (
    <NavigationContainer>
      <Stack.Navigator>
        <Stack.Screen name="Main" component={HomeTabs} options={{ headerShown: false }} />
        <Stack.Screen name="Profile" component={ProfileScreen} />
      </Stack.Navigator>
    </NavigationContainer>
  );
}
```

### State Management (Zustand)

```tsx
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';

interface AuthState {
  user: User | null;
  token: string | null;
  isAuthenticated: boolean;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set) => ({
      user: null,
      token: null,
      isAuthenticated: false,
      login: async (email, password) => {
        const response = await api.login(email, password);
        set({ user: response.user, token: response.token, isAuthenticated: true });
      },
      logout: () => {
        set({ user: null, token: null, isAuthenticated: false });
      },
    }),
    {
      name: 'auth-storage',
      storage: createJSONStorage(() => AsyncStorage),
    }
  )
);
```

### API Service

```tsx
import axios from 'axios';

const api = axios.create({
  baseURL: 'https://api.example.com',
  timeout: 10000,
  headers: { 'Content-Type': 'application/json' },
});

// Request interceptor (add auth token)
api.interceptors.request.use(async (config) => {
  const token = await AsyncStorage.getItem('token');
  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }
  return config;
});

// Response interceptor (handle errors)
api.interceptors.response.use(
  (response) => response,
  async (error) => {
    if (error.response?.status === 401) {
      // Token expired, logout user
      useAuthStore.getState().logout();
    }
    return Promise.reject(error);
  }
);

export default api;
```

---

## Part 3: Flutter Patterns

### Project Structure

```
lib/
├── main.dart
├── app/
│   ├── app.dart
│   └── routes.dart
├── core/
│   ├── constants/
│   ├── theme/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── home/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── shared/
    ├── widgets/
    └── services/
```

### Navigation (GoRouter)

```dart
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/profile/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return ProfileScreen(userId: userId);
      },
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
  ],
);
```

### State Management (Riverpod)

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State provider
final counterProvider = StateNotifierProvider<CounterNotifier, int>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends StateNotifier<int> {
  CounterNotifier() : super(0);
  
  void increment() => state++;
  void decrement() => state--;
}

// Future provider (API call)
final userProvider = FutureProvider<User>((ref) async {
  final api = ref.watch(apiProvider);
  return api.getCurrentUser();
});

// Usage in widget
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final userAsync = ref.watch(userProvider);
    
    return userAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (user) => Text('Hello, ${user.name}! Count: $count'),
    );
  }
}
```

### Custom Widget

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const CustomButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
```

---

## Part 4: Mobile-Specific Patterns

### Push Notifications

```tsx
// React Native - Firebase Cloud Messaging
import messaging from '@react-native-firebase/messaging';

async function requestPermission() {
  const authStatus = await messaging().requestPermission();
  const enabled = authStatus === messaging.AuthorizationStatus.AUTHORIZED;
  
  if (enabled) {
    const token = await messaging().getToken();
    await saveTokenToServer(token);
  }
}

// Handle foreground messages
messaging().onMessage(async (remoteMessage) => {
  showNotification(remoteMessage.notification);
});

// Handle background messages
messaging().setBackgroundMessageHandler(async (remoteMessage) => {
  await processBackgroundMessage(remoteMessage);
});
```

### Offline Support

```tsx
// React Native - AsyncStorage for offline data
import AsyncStorage from '@react-native-async-storage/async-storage';

class OfflineStorage {
  static async save(key: string, data: any) {
    const envelope = { data, timestamp: Date.now() };
    await AsyncStorage.setItem(key, JSON.stringify(envelope));
  }
  
  static async get(key: string, maxAge: number = 3600000) {
    const raw = await AsyncStorage.getItem(key);
    if (!raw) return null;
    
    const { data, timestamp } = JSON.parse(raw);
    if (Date.now() - timestamp > maxAge) {
      await AsyncStorage.removeItem(key);
      return null;
    }
    
    return data;
  }
}

// Use with API calls
async function getDataWithOffline(url: string) {
  const cached = await OfflineStorage.get(url);
  if (cached) return cached;
  
  try {
    const data = await api.get(url);
    await OfflineStorage.save(url, data);
    return data;
  } catch (error) {
    if (cached) return cached; // Fallback to cache on error
    throw error;
  }
}
```

### Performance Optimization

```tsx
// React Native - FlatList optimization
<FlatList
  data={items}
  keyExtractor={(item) => item.id}
  renderItem={({ item }) => <ItemCard item={item} />}
  getItemLayout={(data, index) => ({
    length: ITEM_HEIGHT,
    offset: ITEM_HEIGHT * index,
    index,
  })}
  maxToRenderPerBatch={10}
  windowSize={5}
  removeClippedSubviews={true}
  initialNumToRender={10}
/>

// Image optimization
<Image
  source={{ uri: url }}
  style={{ width: 100, height: 100 }}
  resizeMode="cover"
  fadeDuration={300}
/>
```

---

## Part 5: App Store Deployment

### Build & Release Checklist

```
□ Version number incremented
□ Build number incremented
□ App icon updated (all sizes)
□ Splash screen updated
□ Permissions documented
□ Privacy policy URL added
□ Screenshots updated (all device sizes)
□ App description updated
□ Keywords optimized
□ Release notes written
□ Testing on physical devices
□ Crash reporting enabled
□ Analytics enabled
```

### iOS App Store

```bash
# Build
xcodebuild -workspace ios/App.xcworkspace -scheme App -configuration Release

# Archive
xcodebuild -archivePath build/App.xcarchive -exportArchive -exportOptionsPlist ExportOptions.plist

# Upload
xcrun altool --upload-app -f build/App.ipa -t ios -u apple-id -p app-specific-password
```

### Google Play Store

```bash
# Build APK/AAB
cd android && ./gradlew bundleRelease

# Upload via fastlane
fastlane supply --aab build/app/outputs/bundle/release/app-release.aab
```

---

## Part 6: Testing

### Unit Tests

```tsx
// React Native - Jest
describe('AuthStore', () => {
  it('should login successfully', async () => {
    const { login } = useAuthStore.getState();
    await login('test@example.com', 'password');
    
    const { user, isAuthenticated } = useAuthStore.getState();
    expect(isAuthenticated).toBe(true);
    expect(user).not.toBeNull();
  });
});
```

### Component Tests

```tsx
// React Native - React Native Testing Library
import { render, fireEvent, waitFor } from '@testing-library/react-native';

test('login form submits correctly', () => {
  const onSubmit = jest.fn();
  const { getByPlaceholder, getByText } = render(<LoginForm onSubmit={onSubmit} />);
  
  fireEvent.changeText(getByPlaceholder('Email'), 'test@example.com');
  fireEvent.changeText(getByPlaceholder('Password'), 'password123');
  fireEvent.press(getByText('Login'));
  
  expect(onSubmit).toHaveBeenCalledWith({
    email: 'test@example.com',
    password: 'password123',
  });
});
```

### E2E Tests

```dart
// Flutter - integration_test
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Login flow', (tester) async {
    await tester.pumpWidget(const MyApp());
    
    // Enter credentials
    await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
    await tester.enterText(find.byKey(const Key('password_field')), 'password');
    await tester.tap(find.byKey(const Key('login_button')));
    
    await tester.pumpAndSettle();
    
    // Verify navigation
    expect(find.text('Welcome'), findsOneWidget);
  });
}
```

---

## Output Format

```
## Mobile App Design

### Platform
[React Native / Flutter / Native]

### Architecture
- State management: [tool]
- Navigation: [tool]
- API layer: [pattern]

### Features
1. [Feature 1]
2. [Feature 2]

### Project Structure
[directory layout]

### Deployment
- iOS: [steps]
- Android: [steps]
```

## Rules

- **Design for mobile first** — Small screens, touch inputs, limited bandwidth
- **Handle offline gracefully** — Cache data, show stale content, queue actions
- **Optimize images** — Compress, resize, use appropriate formats
- **Test on real devices** — Simulators don't catch all issues
- **Follow platform guidelines** — iOS HIG and Material Design
- **Handle permissions carefully** — Only ask when needed, explain why
- **Support accessibility** — Screen readers, dynamic text sizes, high contrast
- **Monitor crashes** — Use Crashlytics or Sentry from day one
