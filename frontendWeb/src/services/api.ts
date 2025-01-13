import axios from 'axios';
import { Note } from '../types/Note';

const API_URL = 'https://sticky-notes-week-1.onrender.com/api';

export const api = {
  getNotes: async () => {
    const response = await fetch(`${API_URL}/notes/`);
    if (!response.ok) {
      throw new Error('Error fetching notes');
    }
    return response.json();
  },

  createNote: async (note: Omit<Note, 'id' | 'created_at' | 'updated_at'>): Promise<Note> => {
    const response = await axios.post(`${API_URL}/notes/`, note);
    return response.data;
  },

  updateNote: async (id: number, note: Partial<Note>): Promise<Note> => {
    const response = await axios.patch(`${API_URL}/notes/${id}/`, note);
    return response.data;
  },

  deleteNote: async (id: number): Promise<void> => {
    await axios.delete(`${API_URL}/notes/${id}/`);
  }
}; 