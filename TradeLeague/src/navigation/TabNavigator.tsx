import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { View, Text, StyleSheet } from 'react-native';
import { Colors } from '../constants/colors';
import { LeagueScreen } from '../screens/LeagueScreen';
import { TradeScreen } from '../screens/TradeScreen';
import { PredictScreen } from '../screens/PredictScreen';
import { ProfileScreen } from '../screens/ProfileScreen';

const Tab = createBottomTabNavigator();

const TabIcon = ({ name, focused }: { name: string; focused: boolean }) => {
  const getIcon = () => {
    switch (name) {
      case 'League':
        return '🏆';
      case 'Trade':
        return '📈';
      case 'Predict':
        return '🔮';
      case 'You':
        return '👤';
      default:
        return '⭐';
    }
  };

  return (
    <View style={styles.iconContainer}>
      <Text style={[styles.icon, focused && styles.iconFocused]}>
        {getIcon()}
      </Text>
      <Text style={[styles.label, focused && styles.labelFocused]}>
        {name}
      </Text>
    </View>
  );
};

export const TabNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={{
        tabBarStyle: styles.tabBar,
        tabBarShowLabel: false,
        headerStyle: styles.header,
        headerTintColor: Colors.text.primary,
        headerTitleStyle: styles.headerTitle,
      }}>
      <Tab.Screen
        name="League"
        component={LeagueScreen}
        options={{
          tabBarIcon: ({ focused }) => <TabIcon name="League" focused={focused} />,
        }}
      />
      <Tab.Screen
        name="Trade"
        component={TradeScreen}
        options={{
          tabBarIcon: ({ focused }) => <TabIcon name="Trade" focused={focused} />,
        }}
      />
      <Tab.Screen
        name="Predict"
        component={PredictScreen}
        options={{
          tabBarIcon: ({ focused }) => <TabIcon name="Predict" focused={focused} />,
        }}
      />
      <Tab.Screen
        name="You"
        component={ProfileScreen}
        options={{
          tabBarIcon: ({ focused }) => <TabIcon name="You" focused={focused} />,
        }}
      />
    </Tab.Navigator>
  );
};

const styles = StyleSheet.create({
  tabBar: {
    backgroundColor: Colors.background,
    borderTopWidth: 0,
    height: 80,
    paddingBottom: 20,
    paddingTop: 10,
    elevation: 0,
    shadowOpacity: 0,
  },
  header: {
    backgroundColor: Colors.background,
    elevation: 0,
    shadowOpacity: 0,
    borderBottomWidth: 0,
  },
  headerTitle: {
    fontSize: 20,
    fontWeight: '600',
  },
  iconContainer: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  icon: {
    fontSize: 24,
    marginBottom: 4,
  },
  iconFocused: {
    transform: [{ scale: 1.1 }],
  },
  label: {
    fontSize: 12,
    color: Colors.text.tertiary,
  },
  labelFocused: {
    color: Colors.primary,
  },
});