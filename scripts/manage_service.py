#!/usr/bin/env python
"""
Utility script for managing LLM services on HPC clusters.
"""
import argparse
import subprocess
import sys
import os
from datetime import datetime

def check_gpu_memory():
    """Check available GPU memory."""
    try:
        result = subprocess.run(['nvidia-smi', '--query-gpu=memory.free', '--format=csv,nounits,noheader'],
                              capture_output=True, text=True)
        return [int(x) for x in result.stdout.strip().split('\n')]
    except:
        return None

def setup_logging(log_dir="./logs"):
    """Setup logging directory."""
    os.makedirs(log_dir, exist_ok=True)
    log_file = os.path.join(log_dir, f"llm_service_{datetime.now().strftime('%Y%m%d_%H%M%S')}.log")
    return log_file

def main():
    parser = argparse.ArgumentParser(description='LLM Service Management Tool')
    parser.add_argument('--action', choices=['start', 'stop', 'status'], required=True,
                      help='Action to perform')
    parser.add_argument('--model', default='microsoft/phi-2',
                      help='Model to use (default: microsoft/phi-2)')
    parser.add_argument('--port', type=int, default=8000,
                      help='Port for the API service (default: 8000)')
    
    args = parser.parse_args()
    
    # Check GPU availability
    gpu_memory = check_gpu_memory()
    if not gpu_memory:
        print("No GPU found or nvidia-smi not available")
        sys.exit(1)
    
    # Setup logging
    log_file = setup_logging()
    print(f"Logs will be written to: {log_file}")
    
    # Perform requested action
    if args.action == 'start':
        print(f"Starting LLM service with model {args.model} on port {args.port}")
        # Add service start logic here
    elif args.action == 'stop':
        print("Stopping LLM service")
        # Add service stop logic here
    elif args.action == 'status':
        print("Checking LLM service status")
        # Add status check logic here

if __name__ == '__main__':
    main()