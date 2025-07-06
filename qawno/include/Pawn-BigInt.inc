// MIT License

// Copyright (c) 2025 Northn

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#if !defined PAWN_BIGINT_INC_
  #define PAWN_BIGINT_INC_

  #if !defined PACK_PLUGIN_VERSION
    #define PACK_PLUGIN_VERSION(%0,%1,%2) (((%0) << 16) | ((%1) << 8) | (%2))
  #endif

  #define PAWN_BIGINT_VERSION PACK_PLUGIN_VERSION(1, 0, 0)

  #if !defined __cplusplus
    #define INVALID_BIGINT BigInt:0

    #define MAX_BIGINT_LEN 20
    #define BIGINT_BUF_SIZE ((MAX_BIGINT_LEN) + 1)

    native BigInt:bigint_create(const initial = 0);
    native BigInt:bigint_create_bi(const BigInt:initial);
    native BigInt:bigint_create_str(const initial[]);
    native bool:bigint_destroy(BigInt:bigint);
    native bool:bigint_set(BigInt:bigint, const value);
    native bool:bigint_set_bi(BigInt:bigint, const BigInt:value);
    native bool:bigint_set_str(BigInt:bigint, const value[]);
    native bigint_get(const BigInt:bigint);
    native bool:bigint_get_str(const BigInt:bigint, out[], const out_size = sizeof(out));
    native bool:bigint_fits_cell(const BigInt:bigint);
    native bool:bigint_fits_ucell(const BigInt:bigint);
    native bool:bigint_is_odd(const BigInt:bigint);
    native bool:bigint_is_even(const BigInt:bigint);

    native bool:bigint_add(BigInt:op1, const op2);
    native bool:bigint_add_bi(BigInt:op1, const BigInt:op2);
    native bool:bigint_sub(BigInt:op1, const op2);
    native bool:bigint_sub_bi(BigInt:op1, const BigInt:op2);
    native bool:bigint_mul(BigInt:op1, const op2);
    native bool:bigint_mul_bi(BigInt:op1, const BigInt:op2);
    native bool:bigint_div_q(BigInt:op1, const op2);
    native bool:bigint_div_q_bi(BigInt:op1, const BigInt:op2);
    native bool:bigint_div_r(BigInt:op1, const op2);
    native bool:bigint_div_r_bi(BigInt:op1, const BigInt:op2);
    native bool:bigint_abs(BigInt:op);
    native bool:bigint_neg(BigInt:op);
    native bool:bigint_root(BigInt:op1, const op2);
    native bool:bigint_pow(BigInt:op1, const op2);

    native bigint_cmp(BigInt:op1, const op2);
    native bigint_cmp_bi(BigInt:op1, const BigInt:op2);
    native bigint_cmpabs(BigInt:op1, const op2);
    native bigint_cmpabs_bi(BigInt:op1, const BigInt:op2);

    /*
     * == operations
     */

    stock bool:operator==(BigInt:__oper1, BigInt:__oper2)
    {
      if (_:__oper1 == _:INVALID_BIGINT || _:__oper2 == _:INVALID_BIGINT)
      {
        return _:__oper1 == _:__oper2;
      }
      return bigint_cmp_bi(__oper1, __oper2) == 0;
    }

    stock bool:operator==(BigInt:__oper1, __oper2)
    {
      return bigint_cmp(__oper1, __oper2) == 0;
    }

    stock bool:operator==(__oper1, BigInt:__oper2)
    {
      return bigint_cmp(__oper2, __oper1) == 0;
    }

    /*
     * != operations
     */

    stock bool:operator!=(BigInt:__oper1, BigInt:__oper2)
    {
      if (_:__oper1 == _:INVALID_BIGINT || _:__oper2 == _:INVALID_BIGINT)
      {
        return _:__oper1 != _:__oper2;
      }
      return bigint_cmp_bi(__oper1, __oper2) != 0;
    }

    stock bool:operator!=(BigInt:__oper1, __oper2)
    {
      return bigint_cmp(__oper1, __oper2) != 0;
    }

    stock bool:operator!=(__oper1, BigInt:__oper2)
    {
      return bigint_cmp(__oper2, __oper1) != 0;
    }

    /*
     * > operations
     */

    stock bool:operator>(BigInt:__oper1, BigInt:__oper2)
    {
      return bigint_cmp_bi(__oper1, __oper2) > 0;
    }

    stock bool:operator>(BigInt:__oper1, __oper2)
    {
      return bigint_cmp(__oper1, __oper2) > 0;
    }

    stock bool:operator>(__oper1, BigInt:__oper2)
    {
      return bigint_cmp(__oper2, __oper1) < 0; // inverted because args are inverted too
    }

    /*
     * < operations
     */

    stock bool:operator<(BigInt:__oper1, BigInt:__oper2)
    {
      return bigint_cmp_bi(__oper1, __oper2) < 0;
    }

    stock bool:operator<(BigInt:__oper1, __oper2)
    {
      return bigint_cmp(__oper1, __oper2) < 0;
    }

    stock bool:operator<(__oper1, BigInt:__oper2)
    {
      return bigint_cmp(__oper2, __oper1) > 0; // inverted because args are inverted too
    }

    /*
     * >= operations
     */

    stock bool:operator>=(BigInt:__oper1, BigInt:__oper2)
    {
      return bigint_cmp_bi(__oper1, __oper2) >= 0;
    }

    stock bool:operator>=(BigInt:__oper1, __oper2)
    {
      return bigint_cmp(__oper1, __oper2) >= 0;
    }

    stock bool:operator>=(__oper1, BigInt:__oper2)
    {
      return bigint_cmp(__oper2, __oper1) <= 0; // inverted because args are inverted too
    }

    /*
     * <= operations
     */

    stock bool:operator<=(BigInt:__oper1, BigInt:__oper2)
    {
      return bigint_cmp_bi(__oper1, __oper2) <= 0;
    }

    stock bool:operator<=(BigInt:__oper1, __oper2)
    {
      return bigint_cmp(__oper1, __oper2) <= 0;
    }

    stock bool:operator<=(__oper1, BigInt:__oper2)
    {
      return bigint_cmp(__oper2, __oper1) >= 0; // inverted because args are inverted too
    }
  #else
    #define INVALID_BIGINT 0
  #endif // !defined __cplusplus
#endif // PAWN_BIGINT_INC_
