import React, { useState, useEffect } from 'react';
import axios from 'axios';
import './App.css';

function App() {
  const [tasks, setTasks] = useState([]);
  const [title, setTitle] = useState('');
  const [loading, setLoading] = useState(false);

  const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3001';

  useEffect(() => {
    fetchTasks();
  }, []);

  const fetchTasks = async () => {
    try {
      const response = await axios.get(`${API_URL}/api/tasks`);
      setTasks(response.data);
    } catch (error) {
      console.error('Error fetching tasks:', error);
    }
  };

  const addTask = async () => {
    if (!title.trim()) return;
    
    setLoading(true);
    try {
      await axios.post(`${API_URL}/api/tasks`, { title });
      setTitle('');
      fetchTasks();
    } catch (error) {
      console.error('Error adding task:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>Cloud Native Demo App</h1>
        <div className="task-form">
          <input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            placeholder="Enter task title"
            disabled={loading}
          />
          <button onClick={addTask} disabled={loading}>
            {loading ? 'Adding...' : 'Add Task'}
          </button>
        </div>
        <div className="tasks-list">
          <h2>Tasks</h2>
          {tasks.map(task => (
            <div key={task.id} className="task-item">
              {task.title}
            </div>
          ))}
        </div>
      </header>
    </div>
  );
}

export default App;
