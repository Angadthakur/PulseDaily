const Bookmark = require('../models/Bookmark');

const addBookmark =  async (req, res) => {
    try {
        const { title, description, url, urlToImage, sourceName, publishedAt} =  req.body;

        if(!title || !url){
            return res.status(400).json({  message: 'Title and URL are required'});
        }

        //prevent duplicate bookmarks for the same user
        const existingBookmark =  await Bookmark.findOne({userId: req.user._id, url});
        if(existingBookmark){
            return res.status(400).json({message: 'Bookmark already exists'});
        }

        //bookmark linked to the user
        const newBookmark =  await Bookmark.create({
            userId: req.user._id,
            title,
            description,
            url,
            urlToImage,
            sourceName,
            publishedAt
        });

        res.status(201).json(newBookmark);
    }catch (error){
        res.status(500).json({message: 'Server Error', error: error.message});
    }
};

const getUserBookmarks =  async (req,res) => {
    try{
        //to find all the bookmarks where userId matches
        const bookmarks = await Bookmark.find({userId: req.user._id}).sort({createdAt: -1 });
          
        res.status(200).json(bookmarks);
    }catch(error){
         res.status(500).json({ message: 'Server Error', error: error.message });
    }
};

module.exports = { addBookmark , getUserBookmarks};