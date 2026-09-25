const plugins = [
  '@semantic-release/commit-analyzer',
  '@semantic-release/release-notes-generator',
  '@semantic-release/github',
  ['./release-steam-plugin.mjs', { appId: '294100', branchTargets: { "main": 'stable' }, mods: [{ name: "Fieldwork Companions", path: 'Mod', workshopIds: { stable: "3806133311" } }] }],
];
export default { branches: ["main"], plugins };
