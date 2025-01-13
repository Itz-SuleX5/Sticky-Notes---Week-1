import React, { useState } from 'react';
import {
  Dialog,
  DialogTitle,
  DialogContent,
  DialogActions,
  TextField,
  Button
} from '@mui/material';
import { Note } from '../types/Note';

interface CreateNoteDialogProps {
  open: boolean;
  onClose: () => void;
  onCreate: (note: Omit<Note, 'id' | 'created_at' | 'updated_at'>) => Promise<void>;
}

export const CreateNoteDialog: React.FC<CreateNoteDialogProps> = ({
  open,
  onClose,
  onCreate
}) => {
  const [title, setTitle] = useState('');
  const [content, setContent] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const newNote = {
      title,
      content,
      completed: false,
      position: {
        dx: Math.random() * (window.innerWidth - 250),
        dy: Math.random() * (window.innerHeight - 250)
      },
      rotation: (Math.random() - 0.5) * 0.2
    };

    await onCreate(newNote);
    setTitle('');
    setContent('');
    onClose();
  };

  return (
    <Dialog open={open} onClose={onClose} maxWidth="sm" fullWidth>
      <form onSubmit={handleSubmit}>
        <DialogTitle>Crear Nueva Nota</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            margin="dense"
            label="Título"
            fullWidth
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            required
          />
          <TextField
            margin="dense"
            label="Contenido"
            fullWidth
            multiline
            rows={4}
            value={content}
            onChange={(e) => setContent(e.target.value)}
            required
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose}>Cancelar</Button>
          <Button type="submit" variant="contained" color="primary">
            Crear
          </Button>
        </DialogActions>
      </form>
    </Dialog>
  );
}; 