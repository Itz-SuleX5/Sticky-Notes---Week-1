export interface Note {
  id: number;
  title: string;
  description: string;
  completed: boolean;
  position: {
    dx: number;
    dy: number;
  };
  rotation: number;
  created_at?: string;
  updated_at?: string;
} 