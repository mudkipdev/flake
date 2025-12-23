## Hardware
- CPU: Ryzen 9 9900X
- GPU: Radeon RX 6800 (16 GB VRAM)
- RAM: 64 GB DDR5-6000
- Llama.cpp backend: ROCm

## Inference Speeds
| Model                                   | Quantization | Tokens per Second | Context Size |
| --------------------------------------- | ------------ | ----------------- | ------------ |
| [`glm-4.5-air:106b`](./glm-4.5-air.nix) | Q3_K_M       | 11.8              | 2048         |
| [`qwen3-vl:30b`](./qwen3-vl.nix)        | Q4_K_M       | 34.1              | 8192         |
| [`gemma3:27b`](./gemma3-27b.nix)        | Q4_K_M       | 13.4              | 2048         |

If you have any ideas for better flags, please message me.