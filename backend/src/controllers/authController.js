const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const register = async (req,res) => {
    try{
        const {email, password} =  req.body;

        //checking if user already exists 
        const existingUser = await User.findOne({email});
        if(existingUser){
            return res.status(400).json({message: 'User already exists' });
        }

        //password hashing 
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        //saving user to database
        const newUser = await User.create({
            email,
            password:hashedPassword
        });

        res.status(201).json({message: 'User registered successfully', userId: newUser._id });
    } catch (error){
        res.status(500).json({message :'Server error', error: error.message});
    }
};

const login = async (req,res) => {
    try{
        const {email,password} = req.body;

        //searching user by email
        const user = await User.findOne({email});
        if(!user){
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        //checking if password = hashedpassword
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ message: 'Invalid credentials' });
        }

        //generate a JWT token 
        const token = jwt.sign({id : user._id} , process.env.JWT_SECRET, {expiresIn : '30d'});
        res.status(200).json({ token, email: user.email, userId: user._id });
    }catch(error){
         res.status(500).json({ message: 'Server error', error: error.message });
    }
};

module.exports = { register , login};