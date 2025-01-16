import { useState, useEffect } from 'react';
import { Note } from '../types/Note';

const API_URL = 'https://sticky-notes-week-1.onrender.com/api/notes';

export const useNotes = () => {
  const [notes, setNotes] = useState<Note[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchNotes = async () => {
    try {
      const response = await fetch(API_URL);
      if (!response.ok) throw new Error('Error al cargar las notas');
      const data = await response.json();
      setNotes(data);
      setError(null);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error desconocido');
      console.error('Error fetching notes:', err);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchNotes();
    const interval = setInterval(fetchNotes, 5000);
    return () => clearInterval(interval);
  }, []);

  const createNote = async (note: Omit<Note, 'id' | 'created_at' | 'updated_at'>) => {
    try {
      setError(null);
      console.log('Sending note data to server:', note);
      
      const noteData = {
        title: note.title,
        description: note.description,
        position: {
          dx: note.position.dx,
          dy: note.position.dy
        },
        rotation: note.rotation,
        completed: false
      };

      console.log('Formatted note data:', noteData);
      console.log('Request URL:', API_URL);

      const response = await fetch(API_URL + '/', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify(noteData),
      });

      console.log('Response status:', response.status);
      console.log('Response headers:', Object.fromEntries(response.headers.entries()));

      let responseData;
      const contentType = response.headers.get('content-type');
      if (contentType && contentType.includes('application/json')) {
        responseData = await response.json();
        console.log('Response data:', responseData);
      } else {
        const text = await response.text();
        console.log('Response text:', text);
        responseData = text;
      }

      if (!response.ok) {
        throw new Error(
          typeof responseData === 'object' && responseData.message 
            ? responseData.message 
            : 'Error al crear la nota'
        );
      }

      await fetchNotes();
    } catch (err) {
      console.error('Error creating note:', err);
      setError(err instanceof Error ? err.message : 'Error desconocido');
      throw err;
    }
  };

  const updateNote = async (id: number, note: Partial<Note>) => {
    try {
      setError(null);
      const currentNote = notes.find(n => n.id === id);
      if (!currentNote) throw new Error('Nota no encontrada');

      const updatedNote = {
        ...currentNote,
        ...note,
        position: {
          dx: note.position?.dx || currentNote.position.dx,
          dy: note.position?.dy || currentNote.position.dy
        },
        rotation: note.rotation || currentNote.rotation,
        completed: note.completed !== undefined ? note.completed : currentNote.completed
      };

      const response = await fetch(`${API_URL}/${id}/`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          title: updatedNote.title,
          description: updatedNote.description,
          position: {
            dx: updatedNote.position.dx,
            dy: updatedNote.position.dy
          },
          rotation: updatedNote.rotation,
          completed: updatedNote.completed
        }),
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.message || 'Error al actualizar la nota');
      }

      await fetchNotes();
    } catch (err) {
      console.error('Error updating note:', err);
      setError(err instanceof Error ? err.message : 'Error desconocido');
      throw err;
    }
  };

  const deleteNote = async (id: number) => {
    try {
      setError(null);
      const response = await fetch(`${API_URL}/${id}/`, {
        method: 'DELETE',
      });

      if (!response.ok) {
        const errorData = await response.json().catch(() => ({}));
        throw new Error(errorData.message || 'Error al eliminar la nota');
      }

      await fetchNotes();
    } catch (err) {
      console.error('Error deleting note:', err);
      setError(err instanceof Error ? err.message : 'Error desconocido');
      throw err;
    }
  };

  return {
    notes,
    loading,
    error,
    createNote,
    updateNote,
    deleteNote,
  };
}; 