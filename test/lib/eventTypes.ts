export const EVENT_TYPES = {
  Event: [
    { name: 'chain', type: 'uint256' },
    { name: 'emitter', type: 'address' },
    { name: 'topics', type: 'bytes32[]' },
    { name: 'data', type: 'bytes' },
  ],
} as const;
export const EVENT_PRIMARY_TYPE: keyof typeof EVENT_TYPES = 'Event';
