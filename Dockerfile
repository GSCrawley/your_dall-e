FROM node:18-alpine

WORKDIR /app

# Copy server package.json and package-lock.json to the container
COPY server/package*.json ./server/

# Install server dependencies
RUN npm ci --prefix server --only=production

# Copy client package.json and package-lock.json to the container
COPY client/package*.json ./client/

# Install client dependencies
RUN npm ci --prefix client --only=production

# Copy the built files from the client/dist folder into the container
COPY client/dist/ .

# Expose the port that the Express back end will listen on
EXPOSE 3000

# Start the Express back end
CMD [ "npm", "start", "--prefix", "server" ]
