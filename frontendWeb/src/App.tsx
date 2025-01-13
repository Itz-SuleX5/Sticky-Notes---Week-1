import React from 'react';
import { CssBaseline, ThemeProvider, createTheme } from '@mui/material';
import { HomePage } from './pages/HomePage';

const theme = createTheme({
  palette: {
    primary: {
      main: '#2196f3'
    },
    background: {
      default: '#f5f5f5'
    }
  }
});

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <HomePage />
    </ThemeProvider>
  );
}

export default App; 