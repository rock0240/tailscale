const { checkConnectivity } = require('../src/index');

const run = async () => {
  console.log('Running connectivity tests...\n');

  const hosts = [
    '1.1.1.1',
    '8.8.8.8',
  ];

  let passed = 0;
  let failed = 0;

  for (const host of hosts) {
    const result = await checkConnectivity(host);
    console.log(`  ${host}: ${result.ok ? 'PASS' : 'FAIL'}`);
    if (result.ok) passed++; else failed++;
  }

  console.log(`\nResults: ${passed} passed, ${failed} failed`);
  process.exit(failed > 0 ? 1 : 0);
};

run();
