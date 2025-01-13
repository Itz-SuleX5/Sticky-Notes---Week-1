import React, { useState, useRef } from 'react';
import { Card, CardContent, Typography, IconButton, Switch, Box } from '@mui/material';
import DeleteIcon from '@mui/icons-material/Delete';
import { Note } from '../types/Note';

interface NoteCardProps {
  note: Note;
  onUpdate: (id: number, note: Partial<Note>) => Promise<void>;
  onDelete: (id: number) => Promise<void>;
}

export const NoteCard: React.FC<NoteCardProps> = ({ note, onUpdate, onDelete }) => {
  const [isDragging, setIsDragging] = useState(false);
  const [position, setPosition] = useState({ x: note.position.dx, y: note.position.dy });
  const dragStart = useRef({ x: 0, y: 0 });
  const cardRef = useRef<HTMLDivElement>(null);

  const handleMouseDown = (e: React.MouseEvent) => {
    setIsDragging(true);
    dragStart.current = {
      x: e.clientX - position.x,
      y: e.clientY - position.y
    };
  };

  const handleMouseMove = (e: React.MouseEvent) => {
    if (!isDragging) return;

    const newX = e.clientX - dragStart.current.x;
    const newY = e.clientY - dragStart.current.y;

    setPosition({ x: newX, y: newY });
  };

  const handleMouseUp = async () => {
    if (isDragging) {
      setIsDragging(false);
      await onUpdate(note.id, {
        position: {
          dx: position.x,
          dy: position.y
        }
      });
    }
  };

  const handleToggleComplete = async () => {
    await onUpdate(note.id, { completed: !note.completed });
  };

  const handleDelete = async () => {
    await onDelete(note.id);
  };

  return (
    <Box
      ref={cardRef}
      onMouseDown={handleMouseDown}
      onMouseMove={handleMouseMove}
      onMouseUp={handleMouseUp}
      onMouseLeave={handleMouseUp}
      sx={{
        position: 'absolute',
        left: position.x,
        top: position.y,
        transform: `rotate(${note.rotation}rad)`,
        cursor: isDragging ? 'grabbing' : 'grab',
        zIndex: isDragging ? 1000 : 1,
        userSelect: 'none'
      }}
    >
      <Card
        sx={{
          width: 200,
          backgroundColor: note.completed ? '#B4E4B4' : '#FFE17D',
          boxShadow: '3px 3px 5px rgba(0,0,0,0.2)'
        }}
      >
        <CardContent>
          <Box display="flex" justifyContent="space-between" alignItems="center">
            <Switch
              checked={note.completed}
              onChange={handleToggleComplete}
              size="small"
            />
            <IconButton size="small" onClick={handleDelete}>
              <DeleteIcon />
            </IconButton>
          </Box>
          <Typography variant="h6" gutterBottom>
            {note.title}
          </Typography>
          <Typography variant="body2">
            {note.content}
          </Typography>
        </CardContent>
      </Card>
    </Box>
  );
}; 