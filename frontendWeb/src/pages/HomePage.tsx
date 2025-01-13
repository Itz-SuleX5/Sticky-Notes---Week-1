import React, { useState } from 'react';
import { Box, Fab, CircularProgress } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { NoteCard } from '../components/NoteCard';
import { CreateNoteDialog } from '../components/CreateNoteDialog';
import { useNotes } from '../hooks/useNotes';

export const HomePage: React.FC = () => {
  const { notes, loading, error, createNote, updateNote, deleteNote } = useNotes();
  const [isDialogOpen, setIsDialogOpen] = useState(false);

  if (loading) {
    return (
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        minHeight="100vh"
      >
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return (
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        minHeight="100vh"
        color="error.main"
      >
        {error}
      </Box>
    );
  }

  return (
    <Box
      sx={{
        minHeight: '100vh',
        background: 'linear-gradient(45deg, #8B4513 0%, #A0522D 50%, #8B4513 100%)',
        position: 'relative',
        overflow: 'hidden',
        '&::before': {
          content: '""',
          position: 'absolute',
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          background: 'url("data:image/svg+xml,%3Csvg width=\'70\' height=\'70\' viewBox=\'0 0 70 70\' xmlns=\'http://www.w3.org/2000/svg\'%3E%3Cg fill=\'%23000000\' fill-opacity=\'0.1\' fill-rule=\'evenodd\'%3E%3Cpath d=\'M0 0h35v35H0V0zm35 35h35v35H35V35z\'/%3E%3C/g%3E%3C/svg%3E")',
          opacity: 0.1,
          zIndex: 0
        }
      }}
    >
      <Box
        sx={{
          position: 'relative',
          zIndex: 1,
          minHeight: '100vh'
        }}
      >
        {notes.map((note) => (
          <NoteCard
            key={note.id}
            note={note}
            onUpdate={updateNote}
            onDelete={deleteNote}
          />
        ))}

        <Fab
          color="primary"
          sx={{
            position: 'fixed',
            bottom: 16,
            right: 16
          }}
          onClick={() => setIsDialogOpen(true)}
        >
          <AddIcon />
        </Fab>

        <CreateNoteDialog
          open={isDialogOpen}
          onClose={() => setIsDialogOpen(false)}
          onCreate={createNote}
        />
      </Box>
    </Box>
  );
}; 