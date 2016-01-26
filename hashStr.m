function h = hashStr(s)

% Hash an arbitrary string into a 32-character representation using MD5
%
% Code taken from:
% http://www.mathworks.com/matlabcentral/answers/45323-how-to-calculate-hash-sum-of-a-string-using-java

import java.security.*;
import java.math.*;
import java.lang.String;

md = MessageDigest.getInstance('MD5');
hash = md.digest(double(s));
bi = BigInteger(1, hash);
h = char(String.format('%032x', bi));
