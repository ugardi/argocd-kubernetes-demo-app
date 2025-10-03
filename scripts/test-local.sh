#!/bin/bash

# Test the application locally
cd src/backend
npm install
DB_HOST=localhost DB_PORT=5432 DB_NAME=demoapp DB_USER=postgres DB_PASSWORD=postgres123 npm start &
BACKEND_PID=$!

cd ../frontend
npm install
REACT_APP_API_URL=http://localhost:3001 npm start &
FRONTEND_PID=$!

echo "Frontend running on http://localhost:3000"
echo "Backend running on http://localhost:3001"
echo "Press Ctrl+C to stop"

trap "kill $BACKEND_PID $FRONTEND_PID; exit" INT
wait