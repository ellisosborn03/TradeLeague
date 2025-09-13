import React from 'react';
import {
  View,
  Text,
  Image,
  StyleSheet,
  ViewStyle,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import { Colors } from '../constants/colors';
import { Typography } from '../constants/typography';

interface AvatarProps {
  source?: string;
  name?: string;
  size?: 'small' | 'medium' | 'large';
  style?: ViewStyle;
  showBorder?: boolean;
  rank?: number;
}

export const Avatar: React.FC<AvatarProps> = ({
  source,
  name = '',
  size = 'medium',
  style,
  showBorder = false,
  rank,
}) => {
  const getSizeStyle = () => {
    switch (size) {
      case 'small':
        return styles.small;
      case 'large':
        return styles.large;
      default:
        return styles.medium;
    }
  };

  const getTextSize = () => {
    switch (size) {
      case 'small':
        return styles.textSmall;
      case 'large':
        return styles.textLarge;
      default:
        return styles.textMedium;
    }
  };

  const initials = name
    .split(' ')
    .map(word => word[0])
    .join('')
    .toUpperCase()
    .slice(0, 2);

  const avatarContent = source ? (
    <Image source={{ uri: source }} style={[styles.image, getSizeStyle()]} />
  ) : (
    <LinearGradient
      colors={Colors.gradients.primary}
      style={[styles.gradient, getSizeStyle()]}>
      <Text style={[styles.initials, getTextSize()]}>{initials}</Text>
    </LinearGradient>
  );

  return (
    <View style={[styles.container, style]}>
      {showBorder ? (
        <LinearGradient
          colors={Colors.gradients.primary}
          style={[styles.border, getSizeStyle()]}>
          <View style={[styles.innerBorder, getSizeStyle()]}>
            {avatarContent}
          </View>
        </LinearGradient>
      ) : (
        avatarContent
      )}
      {rank && rank <= 3 && (
        <View style={[styles.rankBadge, size === 'small' && styles.rankBadgeSmall]}>
          <Text style={styles.rankText}>{rank}</Text>
        </View>
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    position: 'relative',
  },
  image: {
    borderRadius: 100,
  },
  gradient: {
    borderRadius: 100,
    alignItems: 'center',
    justifyContent: 'center',
  },
  border: {
    borderRadius: 100,
    padding: 2,
  },
  innerBorder: {
    borderRadius: 100,
    backgroundColor: Colors.background,
    padding: 2,
  },
  small: {
    width: 32,
    height: 32,
  },
  medium: {
    width: 48,
    height: 48,
  },
  large: {
    width: 64,
    height: 64,
  },
  initials: {
    color: Colors.text.primary,
    fontWeight: '600',
  },
  textSmall: {
    fontSize: 12,
  },
  textMedium: {
    fontSize: 16,
  },
  textLarge: {
    fontSize: 24,
  },
  rankBadge: {
    position: 'absolute',
    bottom: -4,
    right: -4,
    backgroundColor: Colors.warning,
    borderRadius: 12,
    width: 24,
    height: 24,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: Colors.background,
  },
  rankBadgeSmall: {
    width: 18,
    height: 18,
    bottom: -2,
    right: -2,
  },
  rankText: {
    color: Colors.text.inverse,
    fontSize: 12,
    fontWeight: '700',
  },
});