#!/bin/bash

echo "Setting up Go Web Services Observability Stack..."
echo "=================================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Docker is not running. Please start Docker first."
    exit 1
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "docker-compose is not installed. Please install docker-compose first."
    exit 1
fi

echo "Docker and docker-compose are available"

# Pull images first to show progress
echo "Pulling Docker images (this may take a few minutes)..."
docker-compose pull

# Start the services
echo "🔄 Starting observability services..."
docker-compose up -d

echo ""
echo "Waiting for services to be ready..."
sleep 10

echo ""
echo "Checking service status..."
docker-compose ps

echo ""
echo "🎉 Observability stack is ready!"
echo ""
echo "📈 Access URLs:"
echo "   Grafana:        http://localhost:3000 (admin/admin)"
echo "   Victoria Metrics: http://localhost:8428"
echo "   Victoria Logs:  http://localhost:9428"
echo ""
echo "To view logs: docker-compose logs -f [service-name]"
echo "To stop: docker-compose down"
echo ""
echo "See README.md for detailed documentation"
