---
name: mobile-development
description: >-
  Build cross-platform and native mobile apps with React Native, Flutter, and platform-native code.
  TRIGGERS: mobile app, React Native, Flutter, iOS development, Android development, cross-platform mobile, mobile UI, push notifications, app store deployment,
  توسعه موبایل, اپلیکیشن موبایل, ری‌اکت نیتیو, فلاتر, توسعه iOS, توسعه Android,
  移动开发, React Native开发, Flutter开发, 跨平台移动应用, 应用商店上架
priority: P1
dependencies: [performance-optimization]
conflicts: []
---

# Mobile Development Skill

## Overview

Mobile application development spans three distinct paradigms: cross-platform frameworks (React Native, Flutter) that share code across iOS and Android, and native development using platform-specific languages (Swift/Kotlin). This skill provides production-grade patterns for every phase of the mobile lifecycle — from architecture and navigation to offline-first data strategies, push notification systems, app store deployment, and performance monitoring. Each framework section includes real-world code patterns, not toy examples, reflecting how mature mobile teams structure their applications.

## When to Use This Skill (6-9 bullets)

- **Building a new mobile application** from scratch that targets both iOS and Android platforms
- **Choosing between React Native, Flutter, or native** development based on project requirements and team expertise
- **Implementing complex navigation patterns** — nested stacks, deep linking, authentication flows, and tab-based navigation
- **Designing offline-first data architectures** that cache, sync, and queue mutations when network is unavailable
- **Setting up push notification systems** with Firebase Cloud Messaging, APNs, and in-app notification handling
- **Preparing for app store submission** — iOS App Store and Google Play Store guidelines, screenshots, metadata, review processes
- **Optimizing mobile performance** — startup time, memory management, frame rates, battery usage, and bundle size
- **Integrating platform-specific features** — camera, biometrics, location, file system, background tasks
- **Testing mobile applications** — unit tests, component tests, E2E tests across device form factors

## When NOT to Use This Skill (5-7 bullets)

- **Building a responsive web application** — use web development skills; mobile-specific patterns don't apply
- **Creating a Progressive Web App (PWA)** — PWAs use web technologies, not native mobile frameworks
- **Developing desktop applications** — Electron/Tauri use different patterns than mobile
- **Building a backend API** — backend skills apply; this is about client-side mobile apps
- **Creating a chatbot or voice assistant** — different interaction paradigm
- **Designing UI mockups** — this skill covers implementation, not visual design in Figma/Sketch
- **Writing mobile device drivers or firmware** — this is application-level development

## Workflow

### Step 1: Project Initialization and Structure

```bash
# React Native (Expo managed workflow)
npx create-expo-app MyApp --template blank-typescript
cd MyApp
npx expo install @react-navigation/native @react-navigation/stack react-native-screens react-native-safe-area-context

# React Native (bare workflow with Expo modules)
npx create-expo-app MyApp --template bare-minimum

# Flutter
flutter create my_app --org com.example --platforms ios,android
cd my_app
flutter pub add flutter_riverpod go_router dio flutter_secure_storage
```

```
# Recommended project structure (React Native / Expo)
src/
├── app/                    # App entry point and providers
│   ├── App.tsx
│   └── providers/
│       ├── AuthProvider.tsx
│       ├── QueryProvider.tsx
│       └── ThemeProvider.tsx
├── features/               # Feature modules (domain-driven)
│   ├── auth/
│   │   ├── screens/
│   │   │   ├── LoginScreen.tsx
│   │   │   └── RegisterScreen.tsx
│   │   ├── components/
│   │   │   ├── LoginForm.tsx
│   │   │   └── SocialLoginButtons.tsx
│   │   ├── hooks/
│   │   │   └── useAuth.ts
│   │   ├── services/
│   │   │   └── authService.ts
│   │   └── types/
│   │       └── auth.types.ts
│   ├── home/
│   │   ├── screens/
│   │   ├── components/
│   │   └── hooks/
│   └── profile/
│       ├── screens/
│       ├── components/
│       └── hooks/
├── shared/                 # Shared components and utilities
│   ├── components/
│   │   ├── Button/
│   │   ├── Card/
│   │   ├── Input/
│   │   ├── Modal/
│   │   └── index.ts
│   ├── hooks/
│   │   ├── useKeyboard.ts
│   │   ├── useColorScheme.ts
│   │   └── useDebounce.ts
│   ├── utils/
│   │   ├── format.ts
│   │   ├── validation.ts
│   │   └── constants.ts
│   ├── theme/
│   │   ├── colors.ts
│   │   ├── typography.ts
│   │   └── spacing.ts
│   └── types/
│       └── index.ts
├── navigation/
│   ├── RootNavigator.tsx
│   ├── AuthNavigator.tsx
│   ├── MainTabNavigator.tsx
│   └── linking.ts
├── services/
│   ├── api/
│   │   ├── client.ts
│   │   ├── interceptors.ts
│   │   └── endpoints/
│   ├── storage/
│   │   ├── secure.ts
│   │   └── local.ts
│   └── notifications/
│       └── push.ts
└── __tests__/
    ├── unit/
    ├── integration/
    └── e2e/
```

### Step 2: Navigation Setup

```tsx
// navigation/RootNavigator.tsx
import React from 'react';
import { NavigationContainer, DefaultTheme, DarkTheme } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { useColorScheme } from 'react-native';
import { AuthNavigator } from './AuthNavigator';
import { MainTabNavigator } from './MainTabNavigator';
import { useAuthStore } from '../features/auth/hooks/useAuth';
import { linking } from './linking';

type RootStackParamList = {
  Auth: undefined;
  Main: undefined;
};

const Stack = createNativeStackNavigator<RootStackParamList>();

export function RootNavigator() {
  const colorScheme = useColorScheme();
  const isAuthenticated = useAuthStore((s) => s.isAuthenticated);

  return (
    <NavigationContainer
      linking={linking}
      theme={colorScheme === 'dark' ? DarkTheme : DefaultTheme}
    >
      <Stack.Navigator screenOptions={{ headerShown: false }}>
        {isAuthenticated ? (
          <Stack.Screen name="Main" component={MainTabNavigator} />
        ) : (
          <Stack.Screen name="Auth" component={AuthNavigator} />
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
```

```tsx
// navigation/MainTabNavigator.tsx
import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import { HomeScreen } from '../features/home/screens/HomeScreen';
import { ProfileScreen } from '../features/profile/screens/ProfileScreen';
import { SettingsScreen } from '../features/settings/screens/SettingsScreen';
import { NotificationBell } from '../shared/components/NotificationBell';

type MainTabParamList = {
  HomeTab: undefined;
  ProfileTab: undefined;
  SettingsTab: undefined;
};

type HomeStackParamList = {
  Home: undefined;
  ItemDetail: { itemId: string };
};

const Tab = createBottomTabNavigator<MainTabParamList>();
const HomeStack = createNativeStackNavigator<HomeStackParamList>();

function HomeStackNavigator() {
  return (
    <HomeStack.Navigator>
      <HomeStack.Screen
        name="Home"
        component={HomeScreen}
        options={{ headerRight: () => <NotificationBell /> }}
      />
      <HomeStack.Screen name="ItemDetail" component={ItemDetailScreen} />
    </HomeStack.Navigator>
  );
}

export function MainTabNavigator() {
  return (
    <Tab.Navigator screenOptions={{ tabBarActiveTintColor: '#007bff' }}>
      <Tab.Screen
        name="HomeTab"
        component={HomeStackNavigator}
        options={{
          title: 'Home',
          headerShown: false,
          tabBarIcon: ({ color, size }) => <HomeIcon color={color} size={size} />,
        }}
      />
      <Tab.Screen
        name="ProfileTab"
        component={ProfileScreen}
        options={{
          title: 'Profile',
          tabBarIcon: ({ color, size }) => <UserIcon color={color} size={size} />,
        }}
      />
      <Tab.Screen
        name="SettingsTab"
        component={SettingsScreen}
        options={{
          title: 'Settings',
          tabBarIcon: ({ color, size }) => <GearIcon color={color} size={size} />,
        }}
      />
    </Tab.Navigator>
  );
}
```

### Step 3: State Management with Zustand

```tsx
// features/auth/store/authStore.ts
import { create } from 'zustand';
import { persist, createJSONStorage } from 'zustand/middleware';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { apiClient } from '../../../services/api/client';

interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
}

interface AuthState {
  user: User | null;
  token: string | null;
  refreshToken: string | null;
  isAuthenticated: boolean;
  isLoading: boolean;
  error: string | null;
  login: (email: string, password: string) => Promise<void>;
  register: (name: string, email: string, password: string) => Promise<void>;
  logout: () => void;
  refreshAccessToken: () => Promise<void>;
  clearError: () => void;
}

export const useAuthStore = create<AuthState>()(
  persist(
    (set, get) => ({
      user: null,
      token: null,
      refreshToken: null,
      isAuthenticated: false,
      isLoading: false,
      error: null,

      login: async (email, password) => {
        set({ isLoading: true, error: null });
        try {
          const response = await apiClient.post('/auth/login', { email, password });
          const { user, token, refreshToken } = response.data;
          apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`;
          set({
            user,
            token,
            refreshToken,
            isAuthenticated: true,
            isLoading: false,
          });
        } catch (error: any) {
          const message = error.response?.data?.message || 'Login failed. Please try again.';
          set({ error: message, isLoading: false });
          throw error;
        }
      },

      register: async (name, email, password) => {
        set({ isLoading: true, error: null });
        try {
          const response = await apiClient.post('/auth/register', { name, email, password });
          const { user, token, refreshToken } = response.data;
          apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`;
          set({
            user,
            token,
            refreshToken,
            isAuthenticated: true,
            isLoading: false,
          });
        } catch (error: any) {
          const message = error.response?.data?.message || 'Registration failed.';
          set({ error: message, isLoading: false });
          throw error;
        }
      },

      logout: () => {
        delete apiClient.defaults.headers.common['Authorization'];
        set({
          user: null,
          token: null,
          refreshToken: null,
          isAuthenticated: false,
          error: null,
        });
      },

      refreshAccessToken: async () => {
        const { refreshToken } = get();
        if (!refreshToken) {
          get().logout();
          return;
        }
        try {
          const response = await apiClient.post('/auth/refresh', { refreshToken });
          const { token, refreshToken: newRefreshToken } = response.data;
          apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`;
          set({ token, refreshToken: newRefreshToken });
        } catch {
          get().logout();
        }
      },

      clearError: () => set({ error: null }),
    }),
    {
      name: 'auth-storage',
      storage: createJSONStorage(() => AsyncStorage),
      partialize: (state) => ({
        user: state.user,
        token: state.token,
        refreshToken: state.refreshToken,
        isAuthenticated: state.isAuthenticated,
      }),
    }
  )
);
```

### Step 4: API Client with Interceptors

```tsx
// services/api/client.ts
import axios, { AxiosError, InternalAxiosRequestConfig } from 'axios';
import * as SecureStore from 'expo-secure-store';
import { Platform } from 'react-native';

const BASE_URL = __DEV__
  ? Platform.OS === 'ios' ? 'http://localhost:3000/api' : 'http://10.0.2.2:3000/api'
  : 'https://api.myapp.com/api';

export const apiClient = axios.create({
  baseURL: BASE_URL,
  timeout: 15000,
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

// Request interceptor — attach token
apiClient.interceptors.request.use(
  async (config: InternalAxiosRequestConfig) => {
    const token = await SecureStore.getItemAsync('auth_token');
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor — handle 401, refresh token
let isRefreshing = false;
let failedQueue: Array<{
  resolve: (value: unknown) => void;
  reject: (reason?: unknown) => void;
}> = [];

const processQueue = (error: AxiosError | null, token: string | null) => {
  failedQueue.forEach((promise) => {
    if (error) {
      promise.reject(error);
    } else {
      promise.resolve(token);
    }
  });
  failedQueue = [];
};

apiClient.interceptors.response.use(
  (response) => response,
  async (error: AxiosError) => {
    const originalRequest = error.config as InternalAxiosRequestConfig & { _retry?: boolean };

    if (error.response?.status === 401 && !originalRequest._retry) {
      if (isRefreshing) {
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject });
        }).then((token) => {
          if (originalRequest.headers) {
            originalRequest.headers.Authorization = `Bearer ${token}`;
          }
          return apiClient(originalRequest);
        });
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        const refreshToken = await SecureStore.getItemAsync('refresh_token');
        if (!refreshToken) throw new Error('No refresh token');

        const response = await axios.post(`${BASE_URL}/auth/refresh`, { refreshToken });
        const { token, refreshToken: newRefreshToken } = response.data;

        await SecureStore.setItemAsync('auth_token', token);
        await SecureStore.setItemAsync('refresh_token', newRefreshToken);

        apiClient.defaults.headers.common['Authorization'] = `Bearer ${token}`;
        processQueue(null, token);

        if (originalRequest.headers) {
          originalRequest.headers.Authorization = `Bearer ${token}`;
        }
        return apiClient(originalRequest);
      } catch (refreshError) {
        processQueue(refreshError as AxiosError, null);
        await SecureStore.deleteItemAsync('auth_token');
        await SecureStore.deleteItemAsync('refresh_token');
        // Trigger re-authentication flow
        return Promise.reject(refreshError);
      } finally {
        isRefreshing = false;
      }
    }

    return Promise.reject(error);
  }
);
```

### Step 5: Push Notification Setup

```tsx
// services/notifications/push.ts
import * as Notifications from 'expo-notifications';
import * as Device from 'expo-device';
import { Platform } from 'react-native';
import { apiClient } from '../api/client';

// Configure notification handling
Notifications.setNotificationHandler({
  handleNotification: async () => ({
    shouldShowAlert: true,
    shouldPlaySound: true,
    shouldSetBadge: true,
  }),
});

export async function registerForPushNotifications(): Promise<string | null> {
  if (!Device.isDevice) {
    console.warn('Push notifications require a physical device');
    return null;
  }

  // Check existing permissions
  const { status: existingStatus } = await Notifications.getPermissionsAsync();
  let finalStatus = existingStatus;

  // Request permissions if not already granted
  if (existingStatus !== 'granted') {
    const { status } = await Notifications.requestPermissionsAsync();
    finalStatus = status;
  }

  if (finalStatus !== 'granted') {
    console.warn('Push notification permission not granted');
    return null;
  }

  // Get push token
  const tokenData = await Notifications.getExpoPushTokenAsync({
    projectId: 'your-project-id',
  });
  const pushToken = tokenData.data;

  // Register with backend
  try {
    await apiClient.post('/notifications/register', {
      token: pushToken,
      platform: Platform.OS,
      deviceName: Device.deviceName,
    });
  } catch (error) {
    console.error('Failed to register push token with server:', error);
  }

  // Android notification channel
  if (Platform.OS === 'android') {
    await Notifications.setNotificationChannelAsync('default', {
      name: 'Default',
      importance: Notifications.AndroidImportance.HIGH,
      vibrationPattern: [0, 250, 250, 250],
      lightColor: '#007bff',
    });

    await Notifications.setNotificationChannelAsync('messages', {
      name: 'Messages',
      importance: Notifications.AndroidImportance.HIGH,
      vibrationPattern: [0, 250],
    });
  }

  return pushToken;
}

export function setupNotificationListeners() {
  // Handle foreground notifications
  const foregroundSubscription = Notifications.addNotificationReceivedListener(
    (notification) => {
      console.log('Foreground notification:', notification);
      // Show in-app notification banner or update UI
    }
  );

  // Handle notification taps (app opened from background)
  const backgroundSubscription = Notifications.addNotificationResponseReceivedListener(
    (response) => {
      const { screen, params } = response.notification.request.content.data as {
        screen?: string;
        params?: Record<string, string>;
      };
      // Navigate to relevant screen
      if (screen) {
        // navigationRef.current?.navigate(screen, params);
      }
    }
  );

  // Handle background message handling (expo-task-manager)
  return { foregroundSubscription, backgroundSubscription };
}
```

## Advanced Techniques

### 1. Offline-First Data Architecture

```tsx
// hooks/useOfflineQuery.ts
import { useQuery, UseQueryOptions, UseQueryResult } from '@tanstack/react-query';
import AsyncStorage from '@react-native-async-storage/async-storage';
import NetInfo, { NetInfoState } from '@react-native-community/netinfo';
import { useEffect, useState, useCallback } from 'react';

interface CacheEnvelope<T> {
  data: T;
  timestamp: number;
  version: number;
}

const CACHE_VERSION = 1;

export function useOfflineQuery<TData>(
  key: string,
  fetchFn: () => Promise<TData>,
  options: UseQueryOptions<TData> & {
    staleTime?: number;
    cacheMaxAge?: number;
  } = {}
): UseQueryResult<TData> & { isOffline: boolean; isStale: boolean } {
  const [isOffline, setIsOffline] = useState(false);
  const [isStale, setIsStale] = useState(false);

  // Monitor network state
  useEffect(() => {
    const unsubscribe = NetInfo.addEventListener((state: NetInfoState) => {
      setIsOffline(!state.isConnected);
    });
    return () => unsubscribe();
  }, []);

  // Read from cache
  const getCachedData = useCallback(async (): Promise<TData | null> => {
    try {
      const raw = await AsyncStorage.getItem(`offline-cache:${key}`);
      if (!raw) return null;

      const envelope: CacheEnvelope<TData> = JSON.parse(raw);
      const age = Date.now() - envelope.timestamp;
      const maxAge = options.cacheMaxAge ?? 24 * 60 * 60 * 1000; // 24h default

      if (age > maxAge) {
        await AsyncStorage.removeItem(`offline-cache:${key}`);
        return null;
      }

      setIsStale(age > (options.staleTime ?? 5 * 60 * 1000));
      return envelope.data;
    } catch {
      return null;
    }
  }, [key, options.cacheMaxAge, options.staleTime]);

  // Write to cache
  const setCachedData = useCallback(async (data: TData) => {
    const envelope: CacheEnvelope<TData> = {
      data,
      timestamp: Date.now(),
      version: CACHE_VERSION,
    };
    await AsyncStorage.setItem(`offline-cache:${key}`, JSON.stringify(envelope));
  }, [key]);

  // Query with offline support
  const query = useQuery<TData>({
    queryKey: [key],
    queryFn: async () => {
      try {
        const data = await fetchFn();
        await setCachedData(data);
        return data;
      } catch (error) {
        // On network error, try cache
        if (isOffline) {
          const cached = await getCachedData();
          if (cached) return cached;
        }
        throw error;
      }
    },
    staleTime: options.staleTime ?? 5 * 60 * 1000,
    retry: isOffline ? 0 : 3,
    ...options,
  });

  return { ...query, isOffline, isStale };
}
```

### 2. Biometric Authentication

```tsx
// services/auth/biometrics.ts
import * as LocalAuthentication from 'expo-local-authentication';
import * as SecureStore from 'expo-secure-store';
import { Platform } from 'react-native';

export interface BiometricConfig {
  promptMessage: string;
  cancelLabel?: string;
  disableDeviceFallback?: boolean;
  fallbackLabel?: string;
}

export const BiometricAuth = {
  async isAvailable(): Promise<boolean> {
    const compatible = await LocalAuthentication.hasHardwareAsync();
    const enrolled = await LocalAuthentication.isEnrolledAsync();
    return compatible && enrolled;
  },

  async getBiometricType(): Promise<string | null> {
    const types = await LocalAuthentication.supportedAuthenticationTypesAsync();
    if (types.includes(LocalAuthentication.AuthenticationType.FACIAL_RECOGNITION)) {
      return Platform.OS === 'ios' ? 'Face ID' : 'Face Recognition';
    }
    if (types.includes(LocalAuthentication.AuthenticationType.FINGERPRINT)) {
      return Platform.OS === 'ios' ? 'Touch ID' : 'Fingerprint';
    }
    return null;
  },

  async authenticate(config: BiometricConfig): Promise<boolean> {
    try {
      const result = await LocalAuthentication.authenticateAsync({
        promptMessage: config.promptMessage,
        cancelLabel: config.cancelLabel ?? 'Cancel',
        disableDeviceFallback: config.disableDeviceFallback ?? false,
        fallbackLabel: config.fallbackLabel ?? 'Use Passcode',
      });
      return result.success;
    } catch (error) {
      console.error('Biometric authentication error:', error);
      return false;
    }
  },

  async saveCredentials(key: string, value: string): Promise<void> {
    await SecureStore.setItemAsync(key, value);
  },

  async getCredentials(key: string): Promise<string | null> {
    return SecureStore.getItemAsync(key);
  },

  async deleteCredentials(key: string): Promise<void> {
    await SecureStore.deleteItemAsync(key);
  },

  async loginWithBiometrics(): Promise<boolean> {
    const available = await BiometricAuth.isAvailable();
    if (!available) return false;

    const biometricType = await BiometricAuth.getBiometricType();
    const authenticated = await BiometricAuth.authenticate({
      promptMessage: `Authenticate with ${biometricType}`,
      cancelLabel: 'Use Password',
    });

    if (authenticated) {
      const token = await BiometricAuth.getCredentials('biometric_token');
      if (token) {
        // Auto-login with stored token
        return true;
      }
    }
    return false;
  },
};
```

### 3. Performance Optimization Patterns

```tsx
// shared/hooks/useOptimizedList.ts
import { useCallback, useMemo, useRef } from 'react';
import { FlatList, FlatListProps } from 'react-native';
import { useWindowDimensions } from 'react-native';

// Pre-computed item layout for fixed-height lists
function useItemLayout(itemHeight: number) {
  return useCallback(
    (data: any, index: number) => ({
      length: itemHeight,
      offset: itemHeight * index,
      index,
    }),
    [itemHeight]
  );
}

// Optimized list with performance settings
function OptimizedList<T extends { id: string }>({
  data,
  renderItem,
  itemHeight = 80,
  ...props
}: Omit<FlatListProps<T>, 'getItemLayout' | 'maxToRenderPerBatch' | 'windowSize'> & {
  itemHeight?: number;
}) {
  const flatListRef = useRef<FlatList<T>>(null);
  const { height: screenHeight } = useWindowDimensions();

  const getItemLayout = useItemLayout(itemHeight);

  const keyExtractor = useCallback((item: T) => item.id, []);

  const renderItemOptimized = useCallback(
    ({ item, index }: { item: T; index: number }) => renderItem({ item, index, separators: {} as any }),
    [renderItem]
  );

  return (
    <FlatList
      ref={flatListRef}
      data={data}
      renderItem={renderItemOptimized}
      keyExtractor={keyExtractor}
      getItemLayout={getItemLayout}
      maxToRenderPerBatch={10}
      windowSize={Math.ceil(screenHeight / itemHeight) + 5}
      removeClippedSubviews={true}
      initialNumToRender={Math.ceil(screenHeight / itemHeight) + 2}
      updateCellsBatchingPeriod={50}
      {...props}
    />
  );
}

// Image component with caching and progressive loading
import FastImage from 'react-native-fast-image';

function OptimizedImage({
  uri,
  width,
  height,
  style,
}: {
  uri: string;
  width: number;
  height: number;
  style?: any;
}) {
  return (
    <FastImage
      style={[{ width, height }, style]}
      source={{
        uri,
        priority: FastImage.priority.normal,
        cache: FastImage.cacheControl.immutable,
      }}
      resizeMode={FastImage.resizeMode.cover}
    />
  );
}
```

### 4. Platform-Specific Code (iOS vs Android)

```tsx
// shared/utils/platform.ts
import { Platform, PlatformOSType } from 'react-native';

export const isIOS = Platform.OS === 'ios';
export const isAndroid = Platform.OS === 'android';
export const isWeb = Platform.OS === 'web';

// Platform-specific styles
export const platformStyles = {
  shadow: Platform.select({
    ios: {
      shadowColor: '#000',
      shadowOffset: { width: 0, height: 2 },
      shadowOpacity: 0.1,
      shadowRadius: 4,
    },
    android: {
      elevation: 4,
    },
    default: {},
  }),
  headerHeight: Platform.select({
    ios: 44,
    android: 56,
    default: 44,
  }),
};

// Platform-specific imports (conditional)
const AnalyticsModule = Platform.select({
  ios: () => require('./analytics-ios').default,
  android: () => require('./analytics-android').default,
  default: () => require('./analytics-fallback').default,
})();

// Feature flags per platform
export const features = {
  hapticFeedback: Platform.OS === 'ios',
  backHandler: Platform.OS === 'android',
  safeAreaInsets: Platform.OS === 'ios',
  permissionsDialog: Platform.OS === 'android',
} as const;
```

### 5. Background Tasks and Geolocation

```tsx
// services/background/tasks.ts
import * as BackgroundFetch from 'expo-background-fetch';
import * as TaskManager from 'expo-task-manager';
import * as Location from 'expo-location';
import { apiClient } from '../api/client';

const BACKGROUND_FETCH_TASK = 'background-data-sync';
const LOCATION_TRACKING_TASK = 'location-tracking';

// Define background task
TaskManager.defineTask(BACKGROUND_FETCH_TASK, async () => {
  try {
    // Fetch and cache data
    const response = await apiClient.get('/sync/latest');
    // Process data, update local storage
    console.log('Background sync completed');
    return BackgroundFetch.BackgroundFetchResult.NewData;
  } catch (error) {
    console.error('Background fetch failed:', error);
    return BackgroundFetch.BackgroundFetchResult.Failed;
  }
});

TaskManager.defineTask(LOCATION_TRACKING_TASK, async ({ data, error }) => {
  if (error) {
    console.error('Location tracking error:', error);
    return;
  }

  const locations = data as { locations: Location.LocationObject[] };
  if (locations.locations.length > 0) {
    const location = locations.locations[0];
    // Send to server or process locally
    await apiClient.post('/location/update', {
      latitude: location.coords.latitude,
      longitude: location.coords.longitude,
      timestamp: location.timestamp,
    });
  }
});

// Register background fetch
export async function registerBackgroundFetch() {
  const isRegistered = await TaskManager.isTaskRegisteredAsync(BACKGROUND_FETCH_TASK);
  if (isRegistered) return;

  await BackgroundFetch.registerTaskAsync(BACKGROUND_FETCH_TASK, {
    minimumInterval: 15 * 60, // 15 minutes
    stopOnTerminate: false,
    startOnBoot: true,
  });
}

// Start location tracking
export async function startLocationTracking() {
  const { status: foregroundStatus } = await Location.requestForegroundPermissionsAsync();
  if (foregroundStatus !== 'granted') return;

  const { status: backgroundStatus } = await Location.requestBackgroundPermissionsAsync();
  if (backgroundStatus !== 'granted') {
    console.warn('Background location permission not granted');
    return;
  }

  const isRegistered = await TaskManager.isTaskRegisteredAsync(LOCATION_TRACKING_TASK);
  if (isRegistered) return;

  await Location.startLocationTrackingAsync({
    taskName: LOCATION_TRACKING_TASK,
    activityType: Location.ActivityType.Fitness,
    deferredUpdatesInterval: 60000, // 1 minute
    deferredUpdatesDistance: 100, // 100 meters
    showsBackgroundLocationIndicator: true, // iOS blue bar
  });
}
```

### 6. App Store Deployment Pipeline

```yaml
# .github/workflows/mobile-deploy.yml
name: Mobile Deploy

on:
  push:
    tags: ['v*']

jobs:
  deploy-ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: |
          cd ios && pod install
          cd .. && npm ci

      - name: Build iOS
        run: |
          xcodebuild -workspace ios/MyApp.xcworkspace \
            -scheme MyApp \
            -configuration Release \
            -archivePath build/MyApp.xcarchive \
            archive

      - name: Export IPA
        run: |
          xcodebuild -exportArchive \
            -archivePath build/MyApp.xcarchive \
            -exportOptionsPlist ios/ExportOptions.plist \
            -exportPath build/

      - name: Upload to App Store Connect
        env:
          APPLE_ID: ${{ secrets.APPLE_ID }}
          APPLE_TEAM_ID: ${{ secrets.APPLE_TEAM_ID }}
          APP_SPECIFIC_PASSWORD: ${{ secrets.APPLE_APP_PASSWORD }}
        run: |
          xcrun altool --upload-app \
            -f build/MyApp.ipa \
            -t ios \
            -u "$APPLE_ID" \
            -p "$APP_SPECIFIC_PASSWORD"

  deploy-android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-java@v4
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: npm ci

      - name: Build AAB
        run: |
          cd android && ./gradlew bundleRelease

      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.PLAY_SERVICE_ACCOUNT }}
          packageName: com.example.myapp
          releaseFiles: android/app/build/outputs/bundle/release/app-release.aab
          track: production
```

### 7. Testing Strategy

```tsx
// __tests__/unit/authStore.test.ts
import { renderHook, act } from '@testing-library/react-native';
import { useAuthStore } from '../../features/auth/store/authStore';
import { apiClient } from '../../services/api/client';

jest.mock('../../services/api/client');

describe('AuthStore', () => {
  beforeEach(() => {
    useAuthStore.setState({
      user: null,
      token: null,
      refreshToken: null,
      isAuthenticated: false,
      isLoading: false,
      error: null,
    });
  });

  describe('login', () => {
    it('should login successfully and store tokens', async () => {
      const mockUser = { id: '1', email: 'test@example.com', name: 'Test User' };
      const mockResponse = {
        data: { user: mockUser, token: 'access-123', refreshToken: 'refresh-123' },
      };
      (apiClient.post as jest.Mock).mockResolvedValue(mockResponse);

      const { login } = useAuthStore.getState();
      await login('test@example.com', 'password123');

      const state = useAuthStore.getState();
      expect(state.isAuthenticated).toBe(true);
      expect(state.user).toEqual(mockUser);
      expect(state.token).toBe('access-123');
      expect(state.isLoading).toBe(false);
    });

    it('should handle login failure', async () => {
      const mockError = {
        response: { data: { message: 'Invalid credentials' } },
      };
      (apiClient.post as jest.Mock).mockRejectedValue(mockError);

      const { login } = useAuthStore.getState();
      await expect(login('wrong@example.com', 'wrong')).rejects.toThrow();

      const state = useAuthStore.getState();
      expect(state.isAuthenticated).toBe(false);
      expect(state.error).toBe('Invalid credentials');
    });
  });

  describe('logout', () => {
    it('should clear all auth state', async () => {
      useAuthStore.setState({
        user: { id: '1', email: 'test@example.com', name: 'Test' },
        token: 'token-123',
        isAuthenticated: true,
      });

      useAuthStore.getState().logout();

      const state = useAuthStore.getState();
      expect(state.isAuthenticated).toBe(false);
      expect(state.user).toBeNull();
      expect(state.token).toBeNull();
    });
  });
});
```

```tsx
// __tests__/integration/LoginScreen.test.tsx
import React from 'react';
import { render, fireEvent, waitFor } from '@testing-library/react-native';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { LoginScreen } from '../../features/auth/screens/LoginScreen';
import { useAuthStore } from '../../features/auth/store/authStore';

const createTestQueryClient = () =>
  new QueryClient({
    defaultOptions: {
      queries: { retry: false },
      mutations: { retry: false },
    },
  });

const renderWithProviders = (component: React.ReactElement) => {
  const queryClient = createTestQueryClient();
  return render(
    <QueryClientProvider client={queryClient}>{component}</QueryClientProvider>
  );
};

describe('LoginScreen', () => {
  beforeEach(() => {
    useAuthStore.setState({ isLoading: false, error: null });
  });

  it('should display validation errors for empty fields', async () => {
    const { getByTestId } = renderWithProviders(<LoginScreen />);

    fireEvent.press(getByTestId('login-button'));

    await waitFor(() => {
      expect(getByTestId('email-error')).toHaveTextContent('Email is required');
      expect(getByTestId('password-error')).toHaveTextContent('Password is required');
    });
  });

  it('should submit login with valid credentials', async () => {
    const { getByTestId, getByDisplayValue } = renderWithProviders(<LoginScreen />);

    fireEvent.changeText(getByTestId('email-input'), 'test@example.com');
    fireEvent.changeText(getByTestId('password-input'), 'password123');
    fireEvent.press(getByTestId('login-button'));

    await waitFor(() => {
      expect(useAuthStore.getState().isLoading).toBe(true);
    });
  });

  it('should display error message on failed login', async () => {
    useAuthStore.setState({ error: 'Invalid credentials' });

    const { getByTestId } = renderWithProviders(<LoginScreen />);

    expect(getByTestId('error-message')).toHaveTextContent('Invalid credentials');
  });
});
```

```dart
// integration_test/login_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow', () {
    testWidgets('should login successfully with valid credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify login screen is shown
      expect(find.text('Welcome Back'), findsOneWidget);

      // Enter credentials
      await tester.enterText(find.byKey(const Key('email_field')), 'test@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'password123');

      // Tap login button
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify navigation to home screen
      expect(find.text('Home'), findsOneWidget);
      expect(find.byKey(const Key('home_screen')), findsOneWidget);
    });

    testWidgets('should show error for invalid credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('email_field')), 'wrong@example.com');
      await tester.enterText(find.byKey(const Key('password_field')), 'wrong');
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pumpAndSettle(const Duration(seconds: 2));

      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('should navigate to register screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      await tester.tap(find.text('Create Account'));
      await tester.pumpAndSettle();

      expect(find.text('Create Your Account'), findsOneWidget);
    });
  });
}
```

## Common Patterns

### Pattern 1: Form Handling with Validation

```tsx
// shared/hooks/useForm.ts
import { useState, useCallback } from 'react';

type ValidationRule<T> = {
  validate: (value: T[keyof T], values: T) => boolean;
  message: string;
};

type FormField<T> = {
  initialValue: T[keyof T];
  rules?: ValidationRule<T>[];
};

type FormConfig<T> = {
  fields: { [K in keyof T]: FormField<T> };
  onSubmit: (values: T) => Promise<void>;
};

export function useForm<T extends Record<string, any>>(config: FormConfig<T>) {
  const [values, setValues] = useState<T>(() => {
    const initial = {} as T;
    for (const [key, field] of Object.entries(config.fields)) {
      (initial as any)[key] = (field as FormField<T>).initialValue;
    }
    return initial;
  });

  const [errors, setErrors] = useState<Partial<Record<keyof T, string>>>({});
  const [touched, setTouched] = useState<Partial<Record<keyof T, boolean>>>({});
  const [isSubmitting, setIsSubmitting] = useState(false);

  const validate = useCallback((): boolean => {
    const newErrors: Partial<Record<keyof T, string>> = {};
    let isValid = true;

    for (const [key, field] of Object.entries(config.fields)) {
      const rules = (field as FormField<T>).rules || [];
      for (const rule of rules) {
        if (!rule.validate(values[key], values)) {
          newErrors[key as keyof T] = rule.message;
          isValid = false;
          break;
        }
      }
    }

    setErrors(newErrors);
    return isValid;
  }, [values, config.fields]);

  const handleChange = useCallback(
    <K extends keyof T>(field: K, value: T[K]) => {
      setValues((prev) => ({ ...prev, [field]: value }));
      // Clear error when user types
      if (errors[field]) {
        setErrors((prev) => ({ ...prev, [field]: undefined }));
      }
    },
    [errors]
  );

  const handleBlur = useCallback(
    <K extends keyof T>(field: K) => {
      setTouched((prev) => ({ ...prev, [field]: true }));
      // Validate single field on blur
      const fieldConfig = config.fields[field] as FormField<T>;
      for (const rule of fieldConfig.rules || []) {
        if (!rule.validate(values[field], values)) {
          setErrors((prev) => ({ ...prev, [field]: rule.message }));
          return;
        }
      }
    },
    [values, config.fields]
  );

  const handleSubmit = useCallback(async () => {
    if (!validate()) return;

    setIsSubmitting(true);
    try {
      await config.onSubmit(values);
    } finally {
      setIsSubmitting(false);
    }
  }, [values, validate, config]);

  const reset = useCallback(() => {
    const initial = {} as T;
    for (const [key, field] of Object.entries(config.fields)) {
      (initial as any)[key] = (field as FormField<T>).initialValue;
    }
    setValues(initial);
    setErrors({});
    setTouched({});
  }, [config.fields]);

  return {
    values,
    errors,
    touched,
    isSubmitting,
    handleChange,
    handleBlur,
    handleSubmit,
    reset,
    getFieldProps: (field: keyof T) => ({
      value: values[field],
      onChangeText: (value: any) => handleChange(field, value),
      onBlur: () => handleBlur(field),
      error: touched[field] ? errors[field] : undefined,
    }),
  };
}
```

### Pattern 2: Haptic Feedback Integration

```tsx
// shared/utils/haptics.ts
import * as Haptics from 'expo-haptics';
import { Platform } from 'react-native';

export const haptics = {
  impact: {
    light: () => {
      if (Platform.OS === 'ios') {
        Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
      }
    },
    medium: () => {
      if (Platform.OS === 'ios') {
        Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Medium);
      }
    },
    heavy: () => {
      if (Platform.OS === 'ios') {
        Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Heavy);
      }
    },
  },
  notification: {
    success: () => {
      if (Platform.OS === 'ios') {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);
      }
    },
    warning: () => {
      if (Platform.OS === 'ios') {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Warning);
      }
    },
    error: () => {
      if (Platform.OS === 'ios') {
        Haptics.notificationAsync(Haptics.NotificationFeedbackType.Error);
      }
    },
  },
  selection: () => {
    if (Platform.OS === 'ios') {
      Haptics.selectionAsync();
    }
  },
};

// Usage in components
function LikeButton({ onPress }: { onPress: () => void }) {
  return (
    <Button
      onPress={() => {
        haptics.impact.medium();
        onPress();
      }}
      title="Like"
    />
  );
}
```

### Pattern 3: Deep Linking Configuration

```tsx
// navigation/linking.ts
import { LinkingOptions } from '@react-navigation/native';

type RootStackParamList = {
  Auth: undefined;
  Main: undefined;
  ItemDetail: { itemId: string };
  ResetPassword: { token: string };
};

export const linking: LinkingOptions<RootStackParamList> = {
  prefixes: ['myapp://', 'https://myapp.com'],
  config: {
    screens: {
      Auth: {
        screens: {
          Login: 'login',
          Register: 'register',
          ResetPassword: 'reset-password/:token',
        },
      },
      Main: {
        screens: {
          HomeTab: {
            screens: {
              Home: 'home',
              ItemDetail: 'item/:itemId',
            },
          },
          ProfileTab: 'profile',
          SettingsTab: 'settings',
        },
      },
    },
  },
  // Custom URL handling
  async getInitialURL() {
    const url = await Linking.getInitialURL();
    if (url != null) return url;

    // Handle push notification deep links
    const message = await messaging().getInitialNotification();
    return message?.data?.deepLink;
  },
  // Subscribe to incoming links
  subscribe(listener) {
    const linkingSubscription = Linking.addEventListener('url', ({ url }) => {
      listener(url);
    });

    // Handle push notification deep links when app is in background
    const unsubscribeNotification = messaging().onNotificationOpenedApp((message) => {
      const url = message.data?.deepLink;
      if (url) listener(url);
    });

    return () => {
      linkingSubscription.remove();
      unsubscribeNotification();
    };
  },
};
```

### Pattern 4: Theme and Dark Mode

```tsx
// shared/theme/theme.ts
import { useColorScheme } from 'react-native';

type Theme = {
  colors: {
    primary: string;
    primaryLight: string;
    primaryDark: string;
    secondary: string;
    background: string;
    surface: string;
    card: string;
    text: string;
    textSecondary: string;
    border: string;
    error: string;
    success: string;
    warning: string;
    info: string;
  };
  spacing: {
    xs: number;
    sm: number;
    md: number;
    lg: number;
    xl: number;
    xxl: number;
  };
  borderRadius: {
    sm: number;
    md: number;
    lg: number;
    full: number;
  };
  typography: {
    h1: { fontSize: number; fontWeight: string; lineHeight: number };
    h2: { fontSize: number; fontWeight: string; lineHeight: number };
    h3: { fontSize: number; fontWeight: string; lineHeight: number };
    body: { fontSize: number; fontWeight: string; lineHeight: number };
    caption: { fontSize: number; fontWeight: string; lineHeight: number };
  };
};

const lightTheme: Theme = {
  colors: {
    primary: '#007bff',
    primaryLight: '#4da3ff',
    primaryDark: '#0056b3',
    secondary: '#6c757d',
    background: '#f8f9fa',
    surface: '#ffffff',
    card: '#ffffff',
    text: '#1a1a1a',
    textSecondary: '#666666',
    border: '#dee2e6',
    error: '#dc3545',
    success: '#28a745',
    warning: '#ffc107',
    info: '#17a2b8',
  },
  spacing: { xs: 4, sm: 8, md: 16, lg: 24, xl: 32, xxl: 48 },
  borderRadius: { sm: 4, md: 8, lg: 12, full: 9999 },
  typography: {
    h1: { fontSize: 32, fontWeight: '700', lineHeight: 40 },
    h2: { fontSize: 24, fontWeight: '600', lineHeight: 32 },
    h3: { fontSize: 20, fontWeight: '600', lineHeight: 28 },
    body: { fontSize: 16, fontWeight: '400', lineHeight: 24 },
    caption: { fontSize: 12, fontWeight: '400', lineHeight: 16 },
  },
};

const darkTheme: Theme = {
  ...lightTheme,
  colors: {
    ...lightTheme.colors,
    primary: '#4da3ff',
    primaryLight: '#80c0ff',
    primaryDark: '#007bff',
    background: '#121212',
    surface: '#1e1e1e',
    card: '#1e1e1e',
    text: '#e0e0e0',
    textSecondary: '#aaaaaa',
    border: '#333333',
    error: '#ff6b6b',
    success: '#51cf66',
    warning: '#ffd43b',
    info: '#22b8cf',
  },
};

export function useTheme(): Theme {
  const colorScheme = useColorScheme();
  return colorScheme === 'dark' ? darkTheme : lightTheme;
}

// Provider component
import { ThemeContext } from './ThemeContext';

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const theme = useTheme();
  return <ThemeContext.Provider value={theme}>{children}</ThemeContext.Provider>;
}
```

### Pattern 5: Offline-First Write Queue (Optimistic Mutations)

```typescript
// Writes succeed instantly in UI, sync when connectivity returns.
// Every queued mutation is idempotent (client-generated UUID).
type PendingWrite = { id: string; op: 'create'|'update'|'delete'; payload: unknown; ts: number };

class SyncQueue {
  private key = 'pending_writes';

  async enqueue(op: PendingWrite): Promise<void> {
    const queue = await storage.get<PendingWrite[]>(this.key) ?? [];
    queue.push(op);                       // persist FIRST, then update UI
    await storage.set(this.key, queue);
  }

  async flush(): Promise<{ sent: number; failed: number }> {
    const queue = await storage.get<PendingWrite[]>(this.key) ?? [];
    let sent = 0, failed = 0;
    for (const op of queue) {             // FIFO preserves causality
      try {
        await api.send(op);               // server dedupes on op.id
        sent++;
      } catch (err) {
        if (!isRetryable(err)) {          // 4xx: poison message
          await deadLetter(op);
        } else {
          failed++;                        // keep for next attempt
          break;                           // stop at first failure → keep order
        }
      }
    }
    await storage.set(this.key, queue.slice(sent));
    return { sent, failed };
  }
}

// Wire into NetInfo listener + AppState:
NetInfo.addEventListener(state => { if (state.isConnected) syncQueue.flush(); });
```

**Why this shape:** mobile networks drop constantly. UI updates optimistically from local state, the durable queue replays in order, and the server's idempotency check makes retries safe.

## Edge Cases & Pitfalls

### 1. **React Native Bridge Performance Bottleneck**
Every call from JavaScript to native crosses the bridge, which can become a bottleneck with frequent calls (e.g., animated values, scroll events). **Solution**: Use `useNativeDriver: true` for animations, batch updates with `InteractionManager`, and minimize bridge crossings by computing in native modules when possible.

### 2. **Memory Leaks from Unmounted Components**
API calls, timers, and event listeners that fire after a component unmounts cause memory leaks and React warnings. **Solution**: Always return cleanup functions from `useEffect`. Use AbortController for fetch requests. Cancel Redux subscriptions and subscriptions on unmount.

### 3. **Android Back Button Exits App Unexpectedly**
The Android hardware back button doesn't automatically navigate back in React Navigation — it may exit the app entirely. **Solution**: Use `BackHandler` from React Native, or ensure `@react-navigation/native` is properly configured with a `NavigationContainer` that handles the back action.

### 4. **iOS Safe Area Insets Overlap Content**
Notches, Dynamic Island, and home indicators can overlap content on modern iPhones. **Solution**: Use `SafeAreaView` or `useSafeAreaInsets()` from `react-native-safe-area-context`. Never hardcode top padding — always read from the safe area insets hook.

### 5. **Image Cache Busting on Update**
When you update an image URL without changing the path, users may see stale cached images. **Solution**: Append a cache-busting query parameter (e.g., `?v=2`), use `FastImage` with `cacheControl.immutable`, or use unique file names with content hashing.

### 6. **Expo vs Bare Workflow Limitations**
Expo managed workflow doesn't support all native modules. If you need a custom native SDK, you must eject or use Expo modules. **Solution**: Start with Expo managed. Use `expo-modules-core` for custom native code. Only eject when you've confirmed the required native module isn't available as an Expo package.

### 7. **Flutter Widget Rebuild Performance**
Excessive widget rebuilds cause jank. Using `setState` on large widget trees rebuilds everything. **Solution**: Use `const` constructors, `Selector` with Riverpod, `RepaintBoundary` for expensive widgets, and `shouldRebuild` in custom `AnimatedWidget` subclasses.

### 8. **Push Notification Token Expiration**
Push notification tokens can become invalid when users reinstall the app, change devices, or when providers rotate certificates. **Solution**: Always re-register tokens on app start. Handle `messaging().onTokenRefresh()` for FCM. Store tokens server-side with device metadata for cleanup.

### 9. **Offline Mutations Conflict with Server**
When users make changes offline and the server state has changed, simple re-sync causes data loss. **Solution**: Implement optimistic locking with version numbers, use a queue pattern for offline mutations, and merge changes with conflict resolution (last-write-wins, manual merge, or CRDT).

### 10. **App Store Review Rejections**
Common rejection reasons include placeholder content, broken links, incomplete metadata, crashes, and privacy policy violations. **Solution**: Never submit with test data. Include a privacy policy URL. Test on the latest OS versions. Provide demo accounts if login is required. Review Apple's Human Interface Guidelines and Google Play policies.

### 11. **Dynamic Type / Font Scaling Breaks Layouts**
Users who increase system font size may find text overflowing containers, overlapping buttons, or breaking layouts entirely. **Solution**: Use `Text` components that respect `allowFontScaling`. Set `maxFontSizeMultiplier` on critical text. Test with large accessibility font sizes. Use relative units where possible.

### 12. **Background App Refresh Costs Battery**
Excessive background tasks drain battery and may be throttled or killed by the OS. **Solution**: Use the minimum interval needed (15+ minutes for background fetch). Batch network requests. Use significant location change monitoring instead of continuous GPS. Respect OS-level battery optimization.

### 13. **Hermes vs JavaScriptCore Engine Differences**
Hermes (default in Expo/React Native 0.70+) has different performance characteristics and some API incompatibilities compared to JavaScriptCore. **Solution**: Test your app with Hermes enabled from day one. Don't rely on JSC-specific APIs. Use `hermes-profile-transformer` for debugging performance.

### 14. **iOS Permission Dialogs Cannot Be Re-prompted**
Once a user denies a permission on iOS, the app cannot show the permission dialog again — only a settings redirect is possible. **Solution**: Always explain why you need a permission before requesting it. Use a pre-permission dialog. Never request permissions on app startup — request them contextually when the user performs the action that requires the permission.

## Integration with Other Skills

| Skill | Relationship | How It Integrates |
|-------|-------------|-------------------|
| **CSS Animations** | Animation techniques | React Native Animated API, Flutter implicit/explicit animations |
| **Performance Optimization** | Performance patterns | Bundle size analysis, image optimization, startup profiling |
| **Web Accessibility** | Accessibility patterns | Screen reader support, dynamic text, high contrast modes |
| **API Design** | Backend integration | REST/GraphQL client setup, auth token management, error handling |
| **Testing** | Testing strategy | Unit tests (Jest/Flutter test), component tests, E2E (Detox/Integration Test) |
| **DevOps/CI** | Deployment pipeline | Fastlane, GitHub Actions, app store submission automation |
| **Analytics** | User tracking | Event tracking, funnel analysis, crash reporting (Sentry/Crashlytics) |
| **Security** | Secure storage | Biometric auth, encrypted storage, certificate pinning |

## Output Format Templates

### Template 1: React Native Feature Module

```
## Feature Module: [Feature Name]

### Components
- [Component 1] — [purpose]
- [Component 2] — [purpose]

### Screens
- [Screen 1] — [route]
- [Screen 2] — [route]

### State Management
- Store: [Zustand/Redux/tool]
- Actions: [list of actions]

### API Endpoints
- GET /api/[endpoint]
- POST /api/[endpoint]

### Files
- src/features/[name]/screens/[Screen].tsx
- src/features/[name]/components/[Component].tsx
- src/features/[name]/hooks/use[Hook].ts
- src/features/[name]/services/[Service].ts
```

### Template 2: Flutter Feature Module

```
## Feature Module: [Feature Name]

### Widgets
- [Widget 1] — [purpose]
- [Widget 2] — [purpose]

### Screens
- [Screen 1] — [route]
- [Screen 2] — [route]

### State Management
- Provider: [Riverpod/Provider/Bloc]
- State: [State class]

### Files
- lib/features/[name]/presentation/[Screen].dart
- lib/features/[name]/data/[Repository].dart
- lib/features/[name]/domain/[Model].dart
```

### Template 3: App Store Metadata

```
## App Store Submission

### App Name
[Short, memorable name — 30 chars max iOS, 50 chars max Android]

### Subtitle
[One-line description — 30 chars iOS, 80 chars Android]

### Description
[Full description with features, benefits, and keywords]

### Keywords
[keyword1, keyword2, keyword3, ...]

### Screenshots
- iPhone 6.7": [description]
- iPhone 6.5": [description]
- iPad 12.9": [description]
- Android Phone: [description]
- Android Tablet: [description]

### Version Info
- Version: [x.y.z]
- Build: [build number]
- Minimum OS: iOS [version] / Android API [level]
```

### Template 4: Performance Budget

```
## Mobile Performance Budget

### Startup Metrics
- Cold start: < 2 seconds
- Warm start: < 1 second
- Time to Interactive: < 3 seconds

### Memory
- RAM usage: < 150MB average
- Memory leaks: 0 detected
- Image cache: < 50MB

### Network
- Initial payload: < 5MB
- API response time: < 500ms p95
- Offline support: Full read, queued writes

### Frame Rate
- 60 FPS during animations
- < 1% frame drops during scroll
- No jank on list rendering

### Bundle Size
- Android APK: < 15MB
- iOS IPA: < 20MB
- JS bundle: < 2MB
```

## Rules

1. **Design mobile-first** — every interaction should work with thumbs, not mouse cursors; target 44×44pt minimum touch targets
2. **Handle offline gracefully** — cache data, show stale content with indicators, queue mutations, and sync when connectivity returns
3. **Test on real devices** — simulators don't replicate real memory constraints, network conditions, or sensor behavior
4. **Follow platform guidelines** — iOS Human Interface Guidelines and Material Design are not suggestions; users expect platform-native patterns
5. **Request permissions contextually** — never ask for camera/location/notification permission at startup; ask when the user triggers the feature that needs it
6. **Optimize images aggressively** — use WebP/AVIF, lazy-load off-screen images, set explicit dimensions to prevent layout shifts
7. **Support accessibility** — screen readers, dynamic type sizes, sufficient color contrast, and meaningful labels on all interactive elements
8. **Monitor crashes from day one** — use Sentry or Crashlytics in development; don't wait for production to find crash patterns
9. **Keep bundle size under budget** — every 1MB of JavaScript delays startup by ~100ms; use code splitting and tree shaking
10. **Never store sensitive data in AsyncStorage** — use `expo-secure-store` or platform keychain/keystore for tokens, passwords, and secrets
11. **Use versioned API endpoints** — `/api/v1/` ensures backward compatibility when mobile app updates roll out gradually
12. **Handle deep link edge cases** — app not installed, wrong screen after auth, expired tokens in deep link URLs
13. **Animate on the native thread** — use `useNativeDriver: true` in React Native, `ImplicitlyAnimated` in Flutter to avoid frame drops
14. **Support dark mode** — test both light and dark themes on every screen; use system color scheme as the default
15. **Implement graceful degradation** — if a feature requires hardware (biometrics, NFC, camera), provide a fallback path for devices that lack it
