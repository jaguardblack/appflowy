import { SelectOptionColor } from '@/application/database-yjs';

export const SelectOptionColorMap = {
  [SelectOptionColor.Purple]: '--tint-purple',
  [SelectOptionColor.Pink]: '--tint-pink',
  [SelectOptionColor.LightPink]: '--tint-red',
  [SelectOptionColor.Orange]: '--tint-orange',
  [SelectOptionColor.Yellow]: '--tint-yellow',
  [SelectOptionColor.Lime]: '--tint-lime',
  [SelectOptionColor.Green]: '--tint-green',
  [SelectOptionColor.Aqua]: '--tint-aqua',
  [SelectOptionColor.Blue]: '--tint-blue',
};

export const SelectOptionColorTextMap = {
  [SelectOptionColor.Purple]: 'purpleColor',
  [SelectOptionColor.Pink]: 'pinkColor',
  [SelectOptionColor.LightPink]: 'lightPinkColor',
  [SelectOptionColor.Orange]: 'orangeColor',
  [SelectOptionColor.Yellow]: 'yellowColor',
  [SelectOptionColor.Lime]: 'limeColor',
  [SelectOptionColor.Green]: 'greenColor',
  [SelectOptionColor.Aqua]: 'aquaColor',
  [SelectOptionColor.Blue]: 'blueColor',
} as const;
