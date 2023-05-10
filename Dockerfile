# Use an official Node.js runtime as a parent image
FROM node:18-alpine

# Set the working directory to /app
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the built files into the container
COPY client/dist/ .


# Expose the port that the Express back end will listen on
EXPOSE 3000

# Start the Express back end
CMD ["npm", "start"]
