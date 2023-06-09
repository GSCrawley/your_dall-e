import express from 'express';
import * as dotenv from 'dotenv';
import cors from 'cors';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import https from 'https';
import fs from 'fs';

import connectDB from './mongodb/connect.js';
import postRoutes from './routes/postRoutes.js';
import dalleRoutes from './routes/dalleRoutes.js';

// initialize .env file
dotenv.config();

const app = express();
app.use(express.json({ limit: '50mb' }));
const corsOptions = {
  origin: ['http://localhost:5175', 'https://your-dall-e.onrender.com'],
  allowedHeaders: ['Content-Type']
};

app.use(cors(corsOptions));

app.use(function(req, res, next) {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, PUT, POST, DELETE');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
  next();
});

app.use('/api/v1/post', postRoutes);
app.use('/api/v1/dalle', dalleRoutes);

app.get('/', async (req, res) => {
  res.status(200).json({
    message: 'Hello from DALL.E!',
  });
});

const startServer = async () => {
  try {
    connectDB(process.env.MONGODB_URL);
    app.listen(8080, () => console.log('Server started on port 8080'));

    const currentFilePath = fileURLToPath(import.meta.url);
    const currentDirPath = dirname(currentFilePath);

    const certPath = join(currentDirPath, 'cert.pem');
    const keyPath = join(currentDirPath, 'key.pem');

    const httpsOptions = {
      key: fs.readFileSync(keyPath),
      cert: fs.readFileSync(certPath),
    };

    https
      .createServer(httpsOptions, app)
      .listen(8443, () => console.log('HTTPS Server running on port 8443'));
  } catch (error) {
    console.log(error);
  }
};

startServer();
