from myhdl import block, always_comb, instances, Signal, intbv

@block
def ALU1bit(a, b, carryin, binvert, operation, result, carryout):

    notb = Signal(bool(0))
    mux1_out, and_out, or_out, adder_sum = (Signal(bool(0)), 
                            Signal(bool(0)), Signal(bool(0)), Signal(bool(0)))

    @always_comb
    def comb_not():
        notb.next = (~b) & 1

    @always_comb
    def comb_mux_2_1():
        if binvert:
            mux1_out.next = notb
        else:
            mux1_out.next = b

    @always_comb
    def comb_and():
        and_out.next = a & b

    @always_comb
    def comb_or():
        or_out.next = a | b

    @always_comb
    def comb_adder():
        adder_sum.next = a ^ b ^ carryin
        carryout.next = (a & b) | (carryin & (a ^ b))

    @always_comb
    def comb_mux_4_1():
        if operation == 0:
            result.next = mux1_out
        elif operation == 1:
            result.next = and_out
        elif operation == 2:
            result.next = or_out
        else:
            result.next = adder_sum

    return instances()

if __name__ == "__main__":
    from myhdl import delay, instance, Signal, StopSimulation, bin
    import argparse

    @block
    def test_comb(args):
        result = Signal(bool(0))
        carryout = Signal(bool(0))

        a, b, carryin, binvert = [Signal(bool(0)) for i in range(4)]

        operation = Signal(intbv(0)[2:])

        alu1 = ALU1bit(a, b, carryin, binvert, operation, result, carryout)

        @instance
        def stimulus():
            print("op a b cin bneg | cout res")
            for op in args.op:
                assert 0 <= op <= 3
                for i in range(16):
                    bi = intbv(i)
                    a.next, b.next, carryin.next, binvert.next = \
                        bi[0], bi[1], bi[2], bi[3]
                    operation.next = op
                    yield delay(10)
                    print("{} {} {} {}   {}    | {}    {}".format(
                        bin(op, 2), 
                        int(a), int(b), int(carryin), int(binvert), 
                        int(carryout), int(result)))

            raise StopSimulation()

        return alu1, stimulus

    parser = argparse.ArgumentParser(description='Testing 1-bit ALU')
    parser.add_argument('op', type=int, nargs='*', 
            default=[0, 1, 2], help='operation')
    parser.add_argument('--trace', action='store_true', help='generate trace')
    parser.add_argument('--verbose', '-v', action='store_true', help='verbose')

    args = parser.parse_args()
    if args.verbose:
        print(args)

    tb = test_comb(args)
    tb.config_sim(trace=args.trace)
    tb.run_sim()
