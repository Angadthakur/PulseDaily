const jwt = require('jsonwebtoken');
const User = require('../models/User');

const protect = async ( req , res , next)=> {
    let token;
    
    //checcking if the authorization header exists and starts with "Bearer"
    if(req.headers.authorization && req.headers.authorization.startsWith('Bearer')){
        try{
            //extract the token from header 
            token = req.headers.authorization.split(' ')[1];

            //verifying token using the secret key
            const decoded = jwt.verify(token, process.env.JWT_SECRET);

            //finding user in the database using the ID
            req.user = await User.findById(decoded.id).select('-password');

            next();
        }catch(error){
            console.error(error);
            res.status(401).json({message: 'Not authorized, token failed'});
        }
    }

    if (!token){
        res.status(401).json({message: 'Not authorized, no token'})
    }
};

module.exports = {protect};