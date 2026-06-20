const express = require('express');
const cors =  require('cors');

const authRoutes =  require('./routes/authRoutes');
const bookmarkRoutes = require('./routes/bookmarkRoutes');
const newsRoutes = require('./routes/newsRoutes');
const { notFound, errorHandler } = require('./middleware/errorMiddleware');

const app = express();

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/bookmarks', bookmarkRoutes);
app.use('/api/news', newsRoutes);

app.get('/health', (req,res) =>{
    res.status(200).json({status : 'ok', message: 'News Backend is running'})
});

app.use(notFound);
app.use(errorHandler);

module.exports = app;