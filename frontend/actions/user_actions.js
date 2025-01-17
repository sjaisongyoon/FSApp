import * as APIUtil from '../util/user_util';
export const RECEIVE_USER = 'RECEIVE_USER'

const receiveUser = (user) => ({
    type: RECEIVE_USER,
    user
});


export const fetchUser = (userId) => dispatch =>{
    return APIUtil.fetchUser(userId)
        .then( (user) => dispatch(receiveUser(user)) )
};