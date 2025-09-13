import { Platform } from 'react-native';

const fontFamily = Platform.select({
  ios: {
    regular: 'System',
    medium: 'System',
    semibold: 'System',
    bold: 'System',
    mono: 'Menlo',
  },
  android: {
    regular: 'Roboto',
    medium: 'Roboto-Medium',
    semibold: 'Roboto-Medium',
    bold: 'Roboto-Bold',
    mono: 'monospace',
  },
});

export const Typography = {
  h1: {
    fontFamily: fontFamily?.bold,
    fontSize: 32,
    lineHeight: 40,
    fontWeight: '600' as '600',
  },
  h2: {
    fontFamily: fontFamily?.bold,
    fontSize: 24,
    lineHeight: 32,
    fontWeight: '600' as '600',
  },
  h3: {
    fontFamily: fontFamily?.semibold,
    fontSize: 20,
    lineHeight: 28,
    fontWeight: '600' as '600',
  },
  h4: {
    fontFamily: fontFamily?.semibold,
    fontSize: 18,
    lineHeight: 24,
    fontWeight: '500' as '500',
  },
  body: {
    fontFamily: fontFamily?.regular,
    fontSize: 16,
    lineHeight: 24,
    fontWeight: '400' as '400',
  },
  bodySmall: {
    fontFamily: fontFamily?.regular,
    fontSize: 14,
    lineHeight: 20,
    fontWeight: '400' as '400',
  },
  caption: {
    fontFamily: fontFamily?.regular,
    fontSize: 12,
    lineHeight: 16,
    fontWeight: '400' as '400',
  },
  button: {
    fontFamily: fontFamily?.semibold,
    fontSize: 16,
    lineHeight: 24,
    fontWeight: '600' as '600',
  },
  mono: {
    fontFamily: fontFamily?.mono,
    fontSize: 14,
    lineHeight: 20,
    fontWeight: '400' as '400',
  },
};