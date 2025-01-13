import { useState, useEffect } from 'react';
import { Note } from '../types/Note';
import { api } from '../services/api';

export const useNotes = () => {
  const [notes, setNotes] = useState<Note[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const fetchNotes = async () => {
    try {
      setLoading(true);
      const data = await api.getNotes();
      setNotes(data);
      setError(null);
    } catch (err) {
      setError('Error al cargar las notas');
    } finally {
      setLoading(false);
    }
  };

  const createNote = async (note: Omit<Note, 'id' | 'created_at' | 'updated_at'>): Promise<void> => {
    try {
      const newNote = await api.createNote(note);
      setNotes(prev => [...prev, newNote]);
    } catch (err) {
      setError('Error al crear la nota');
      throw err;
    }
  };

  const updateNote = async (id: number, note: Partial<Note>): Promise<void> => {
    try {
      const updatedNote = await api.updateNote(id, note);
      setNotes(prev => prev.map(n => n.id === id ? updatedNote : n));
    } catch (err) {
      setError('Error al actualizar la nota');
      throw err;
    }
  };

  const deleteNote = async (id: number): Promise<void> => {
    try {
      await api.deleteNote(id);
      setNotes(prev => prev.filter(n => n.id !== id));
    } catch (err) {
      setError('Error al eliminar la nota');
      throw err;
    }
  };

  useEffect(() => {
    fetchNotes();
  }, []);

  return {
    notes,
    loading,
    error,
    createNote,
    updateNote,
    deleteNote,
    refreshNotes: fetchNotes
  };
}; 