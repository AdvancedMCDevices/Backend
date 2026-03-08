# Use the official Node.js image as the base image
FROM node:25-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the rest of the application files
COPY . .

# Install the application dependencies
RUN npm install -g pnpm && pnpm install --frozen-lockfile --shamefully-hoist

# Build the NestJS application
RUN pnpm run build

# Use a smaller base image for the final stage
FROM node:25-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the built application from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Expose the application port
EXPOSE 3000

ENV NODE_ENV=production

# Command to run the application
CMD ["node", "dist/main"]