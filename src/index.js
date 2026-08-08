const { execSync } = require('child_process');
const http = require('http');

const checkConnectivity = (host) => {
  return new Promise((resolve) => {
    const req = http.get(`http://${host}`, (res) => {
      resolve({ host, status: res.statusCode, ok: true });
    });
    req.on('error', () => resolve({ host, status: 0, ok: false }));
    req.setTimeout(5000, () => { req.destroy(); resolve({ host, status: 0, ok: false }); });
  });
};

const getNodeStatus = () => {
  try {
    const output = execSync('tailscale status --json 2>/dev/null', { encoding: 'utf8' });
    return JSON.parse(output);
  } catch {
    return null;
  }
};

module.exports = { checkConnectivity, getNodeStatus };
