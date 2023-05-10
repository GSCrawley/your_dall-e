FROM node:18-alpine

WORKDIR /app

# Copy server package.json and package-lock.json to the container
COPY ./server/package.json /app/server/package.json
COPY ./server/package-lock.json /app/server/package-lock.json

# Install server dependencies
RUN npm ci --prefix server --only=production --no-optional

RUN ls -la /app && npm install
COPY ./server /app

# Copy client package.json and package-lock.json to the container
COPY client/package.json /app/client/package.json
COPY client/package-lock.json /app/client/package-lock.json 

# Install client dependencies
RUN npm ci --prefix client --only=production --no-optional

# Copy the built files from the client/dist folder into the container
COPY client/dist/ .

# Expose the port that the Express back end will listen on
EXPOSE 3000

# Start the Express back end
CMD [ "npm", "start", "--prefix", "server" ]
