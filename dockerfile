# Use the official Node.js image as the base image
FROM node:25

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package.json ./
COPY pnpm-lock.yaml ./
COPY pnpm-workspace.yaml ./

# Install the application dependencies
RUN corepack enable pnpm && pnpm install --frozen-lockfile

# Copy the rest of the application files
COPY . .

# Build the NestJS application
RUN pnpm run build

# Expose the application port
EXPOSE 3000

ENV NODE_ENV=production
ENV API_SECRET=${API_SECRET}

# Command to run the application
CMD ["node", "dist/main"]