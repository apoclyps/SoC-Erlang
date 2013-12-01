% The authors of this work have released all rights to it and placed it
% in the public domain under the Creative Commons CC0 1.0 waiver
% (http://creativecommons.org/publicdomain/zero/1.0/).
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
% EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
% IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
% CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
% TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
% SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% 
% Retrieved from: http://en.literateprograms.org/Pi_with_Machin's_formula_(Erlang)?oldid=16330

-module(machin).
-export([pi/1]).


% Arcott
% ===========================================================================
arccot(X, Unity) ->
    Start = Unity div X,
    arccot(X, Unity, 0, Start, 1, 1).

arccot(_X, _Unity, Sum, XPower, N, _Sign) when XPower div N =:= 0 ->
    Sum;
arccot(X, Unity, Sum, XPower, N, Sign) ->
    Term = XPower div N,
    arccot(X, Unity, Sum + Sign*Term, XPower div (X*X), N+2, -Sign).

% pi
% ===========================================================================
pi(Digits) ->
    Unity = pow(10, Digits+10),
    Pi = 4 * (4 * arccot(5, Unity) - arccot(239, Unity)),
    Pi div pow(10,10).

% power
% ===========================================================================    
pow(Base, Exponent) when Exponent < 0 ->
  pow(1 / Base, -Exponent);

pow(Base, Exponent) when is_integer(Exponent) ->
  pow(Exponent, 1, Base).

pow(0, Product, _Modifier) ->
  Product;

pow(Exponent, Product, Modifier) when Exponent rem 2 =:= 1 ->
  pow(Exponent div 2, Product * Modifier, Modifier * Modifier);

pow(Exponent, Product, Modifier) ->
  pow(Exponent div 2, Product, Modifier * Modifier).
