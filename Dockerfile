FROM node:18-alpine

WORKDIR /app

# Copy client package.json and package-lock.json to the container
COPY client/package*.json ./client/

# Install client dependencies
RUN cd client && npm ci --only=production

# Move into server directory
WORKDIR /app/server

# Copy server package.json and package-lock.json to the container
COPY server/package*.json ./

# Install server dependencies
RUN npm ci --only=production

# Move back to app directory
WORKDIR /app

# Copy the built files from the client/dist folder into the container
COPY client/dist/ .

# Expose the port that the Express back end will listen on
EXPOSE 3000

# Start the Express back end
CMD [ "npm", "start" ]
