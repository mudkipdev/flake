{ modelsDir }:

{
  "hf-repo" = "unsloth/Qwen3-VL-30B-A3B-Instruct-GGUF:Q4_K_M";
  settings = {
    "ctx-size" = 8192;
    "parallel" = 1;
    "n-gpu-layers" = 60;
    "n-cpu-moe" = 8;
    "cache-type-k" = "q8_0";
    "cache-type-v" = "q8_0";
    "threads" = 12;
    "threads-batch" = 12;
    "batch-size" = 64;
    "ubatch-size" = 32;
    "flash-attn" = true;
  };
}
