{ modelsDirectory }:

{
  model = "${modelsDirectory}/GLM-4.5-Air-Q3_K_M-00001-of-00002.gguf";
  settings = {
    "ctx-size" = 2048;
    "parallel" = 1;
    "n-gpu-layers" = 47;
    "n-cpu-moe" = 44;
    "cache-type-k" = "q8_0";
    "cache-type-v" = "q8_0";
    "threads" = 12;
    "threads-batch" = 12;
    "batch-size" = 64;
    "ubatch-size" = 32;
    "flash-attn" = true;
  };
}
