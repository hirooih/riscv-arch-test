# Makefile for RISC-V Architecture Test Suite

PATH := $(PATH):$(PWD)/../sail-riscv/build/c_emulator:/opt/sail/bin
XLEN = 32

# VERBOSE = --verbose debug
CONFIG_INI = rv$(XLEN)i_config.ini
SUITE = riscv-test-suite/rv$(XLEN)i_m
ENV = riscv-test-suite/env
RUN_FLAGS += --no-ref-run
# RUN_FLAGS += --no-dut-run
# RUN_FLAGS += --no-clean

#COV_FLAGS += --no-clean

# run specific tests extracted from test_list.yaml
# RUN_FLAGS += --testfile=my_test_list.yaml

CGFS = \
	coverage/i/rvi.cgf \
	coverage/zimop/zimop.cgf \
	coverage/zicond/zicond.cgf \
	coverage/c/rvi_c.cgf \
	coverage/zcmop/zcmop.cgf \
	coverage/dataset.cgf \
	coverage/Zifencei/rvi_fencei.cgf \
	coverage/priv/rvi_priv.cgf \
	coverage/m/rvi_m.cgf \
	coverage/i/rv$(XLEN)i.cgf \
	coverage/c/rv$(XLEN)i_zcb.cgf \
	coverage/c/rv$(XLEN)ic.cgf \
	coverage/b/rv$(XLEN)i_b.cgf \
	coverage/Zifencei/rv$(XLEN)i_fencei.cgf \
	coverage/pmp/rv$(XLEN)_pmp.cgf \
	coverage/priv/rv$(XLEN)i_priv.cgf \
	coverage/m/rv$(XLEN)im.cgf \

CGF_FLAGS = $(addprefix -c, $(CGFS))

# run the tests on the each of the models and compare the signature values
run:
	riscof $(VERBOSE) $@ --config=$(CONFIG_INI) --suite=$(SUITE) --env=$(ENV) $(RUN_FLAGS)

# collect the ISA coverage metrics of a given test-suite and generate a coverage report in html.
coverage:
	riscof $(VERBOSE) $@ --config=$(CONFIG_INI) --suite=$(SUITE) --env=$(ENV) $(CGF_FLAGS) $(COV_FLAGS)


# check if the input yaml files are configured correctly. (by riscv-config)
validateyaml:
	riscof $(VERBOSE) $@ --config=$(CONFIG_INI)

# Generate Database for the Suite.
#   input:  riscv-test-suite/**/*.S
#   output: riscof_work/database.yaml
gendb:
	riscof $(VERBOSE) $@ --suite=$(SUITE) --env=$(ENV)

# generate the list of tests
#   input:  config.ini, database.yaml, *_isa.yaml, *_platform.yaml
#   output: riscof_work/test_list.yaml
testlist:
	riscof $(VERBOSE) $@ --config=$(CONFIG_INI) --suite=$(SUITE) --env=$(ENV)


clean:
	rm -rf riscof_work

.PHONY: run coverage validateyaml gendb testlist clean
