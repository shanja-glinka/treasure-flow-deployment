module.exports = {
    apps: [
      {
        name: "api-service",
        script: "./api/dist/main.js",
        env_file: "./api/.env",
        instances: 1,
        env: {
          NODE_ENV: "production",
          PORT: 8141
        }
      },
      {
        name: "file-service",
        script: "./file/dist/main.js",
        env_file: "./file/.env",
        instances: 1,
        env: {
          NODE_ENV: "production",
          PORT: 8145
        }
      },
      {
        name: "auction-service",
        script: "./auction/dist/main.js",
        env_file: "./auction/.env",
        instances: 1,
        env: {
          NODE_ENV: "production",
          PORT: 8146
        }
      }
    ]
  };
  