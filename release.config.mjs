const steamPublishEnabled = process.env.STEAM_PUBLISH === 'true';

const plugins = [
  '@semantic-release/commit-analyzer',
  '@semantic-release/release-notes-generator',
  '@semantic-release/github',
];

// Steam is opt-in only from the protected production environment.  A dry run
// cannot read Steam credentials or upload the Workshop directory.
if (steamPublishEnabled) {
  plugins.push([
    'semantic-release-steam',
    {
      appId: '294100',
      branchTargets: { main: 'stable' },
      mods: [{
        name: 'Fieldwork Companions',
        path: 'Mod',
        workshopIds: { stable: '3806133311' },
      }],
    },
  ]);
}

export default {
  branches: ['main'],
  plugins,
};
