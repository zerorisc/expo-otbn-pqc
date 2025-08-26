# Copyright lowRISC contributors (OpenTitan project).
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "rtl_files",
    srcs = glob(
        ["**"],
        exclude = [
            "dv/**",
            "doc/**",
            "README.md",
        ],
    ) + [
        "//hw/ip/otbn/data:all_files",
    ],
)

filegroup(
    name = "doc_files",
    srcs = glob([
        "**/*.md",
        "**/*.svg",
    ]) + [
        "//hw/ip/otbn/dv/otbnsim:doc_files",
    ],
)

load("@bazel-orfs//:openroad.bzl", "orfs_flow","orfs_run")
load("@bazel-orfs//:ppa.bzl", "orfs_ppa")
#load("@rules_python//python:pip.bzl", "compile_pip_requirements")
#load("@bazel-orfs//:write_binary.bzl", "write_binary")


# If you want to run both sky130hd and/or asap7 just comment/uncomment respectively 
PDKS = [
#    "sky130hd",
    "asap7",
]

#BASE_NAME  = "buffer_bit"  # Change this to your module's name
#BASE_NAME  = "otbn_mac_bignum"  # Change this to your module's name
BASE_NAME  = "otbn_alu_bignum"  # Change this to your module's name
#BASE_NAME  = "otbn" # Change this to your module's name


sh_binary(
    name = "sv2v_tool",
    srcs = [":sta/sv2v_wrapper"],
)

load(":sta/sv_rules.bzl", "sv2v_rule")

sv2v_rule(
    name = "rtl_sv2v",
    srcs = glob(["rtl/*.sv", "rtl/bn_vec_core/*.sv"]) + 
      [
        "//hw/ip/tlul:sta_files",
        "//hw/ip/prim:sta_files",
        "//hw/ip/prim_xilinx:sta_files",
        "//hw/ip/prim_generic:sta_files"
      ],
    tool = ":sv2v_tool",
    pkgs = [
       "//hw/top_earlgrey:rtl_files",
       "//hw/ip/edn:rtl_files",
       "//hw/ip/csrng:rtl_files",
       "//hw/ip/entropy_src:rtl_files",
       "//hw/ip/lc_ctrl:rtl_files",
       "//hw/ip/tlul:rtl_files",
       "//hw/ip/prim:rtl_files",
       "//hw/ip/prim_generic:rtl_files",
       "//hw/ip/keymgr:rtl_files",
       "//hw/ip/kmac:rtl_files",
       "//hw/ip/otp_ctrl:rtl_files",
       "rtl_files"
    ],
    includes = ["//hw/ip/prim:rtl_files"],
    defines = ["TOWARDS_ADDER"]
)


filegroup(
    name = BASE_NAME + "_files", 
    srcs = [":rtl_sv2v"],
    visibility = ["//visibility:public"],
)


FASTER = {
    # ignore timing repair for now
    "SKIP_REPORT_METRICS": "1",
    "SKIP_LAST_GASP": "1",
    "GPL_ROUTABILITY_DRIVEN": "0",
    "GPL_TIMING_DRIVEN": "0",
    # skip checks for now, faster
    "PWR_NETS_VOLTAGES": "",
    "GND_NETS_VOLTAGES": "",
    "TNS_END_PERCENT": "0",
}

[orfs_flow(
    name = BASE_NAME,
    arguments =  FASTER | {
                    "SETUP_SLACK_MARGIN": "0.05",
                    "SETUP_HOLD_MARGIN": "-0.05",
                    "SYNTH_HIERARCHICAL": "1",
                    "CORE_UTILIZATION": "60",    # decrease if not sufficient space for pins
                    "PLACE_DENSITY": "0.5",
                    "CORE_MARGIN": "1",
                    "SYNTH_MEMORY_MAX_BITS": "16384",
#                    "PL_RESIZER_HOLD_MAX_BUFFER_PCT" : "50",
#                    "GRT_RESIZER_HOLD_MAX_BUFFER_PCT": "50",
#                    "PL_RESIZER_SETUP_MAX_BUFFER_PCT" : "50",
#                    "GRT_RESIZER_SETUP_MAX_BUFFER_PCT": "50",

                    # Make sure to pass your module's parameter correctly here. 
		    #"VERILOG_TOP_PARAMS": "ADDER {adder}".format(
                    #adder = parameter["ADDER"]),
                } 
                | 
                (
                    {
                        "IO_PLACER_H": "M2 M4",
                        "IO_PLACER_V": "M3 M5",
                    } if pdk == "asap7" else {
                        "IO_PLACER_H": "met3 met5",
                        "IO_PLACER_V": "met2 met4",
                    }
                ),
    pdk = "@docker_orfs//:{}".format(pdk),
    sources = {
        "SDC_FILE": [":sta/constraints_{}.sdc".format(pdk)],
    },
    variant="{pdk}".format(pdk=pdk),
    verilog_files = [":" + BASE_NAME + "_files"],
) for pdk in PDKS]


[orfs_run(
    name = "{base_name}_{pdk}_results".format(base_name=BASE_NAME,pdk=pdk),
    src = "{base_name}_{pdk}_cts".format(base_name=BASE_NAME,pdk=pdk),
    outs = ["{base_name}_{pdk}_stats".format(base_name=BASE_NAME,pdk=pdk),],
    arguments = {
        "OUTPUT": "$(location :{base_name}_{pdk}_stats)".format(base_name=BASE_NAME,pdk=pdk),
    },
    script = ":sta/results.tcl",
) for pdk in PDKS]  


filegroup(
    name = BASE_NAME + "_all_results",
    srcs = [
        ":{base_name}_{pdk}_results".format(
            base_name=BASE_NAME,
            pdk=pdk
        ) for pdk in PDKS
    ],
)

