const mongoose  = require(`mongoose`);

const bookmarkSchema = new mongoose.Schema({
    // We will link this to a specific user later when we add JWT auth
    userId: {
        type: String,
        required: true
    },
    title: {
        type: String,
        required: true
    },
    description: {
        type: String,
        default: ""
    },
    url: {
        type: String,
        required: true
    },
    urlToImage: {
        type: String,
        default: ""
    },
    sourceName: {
        type: String,
        default: ""
    },
    publishedAt: {
        type: Date
    }
}, {
    timestamps: true // Automatically adds createdAt and updatedAt fields
});

const Bookmark = mongoose.model('Bookmark', bookmarkSchema);
module.exports = Bookmark;