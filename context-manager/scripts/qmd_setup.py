#!/usr/bin/env python3
"""
Setup qmd collection for context directory semantic search.
Creates and configures a qmd collection for .context/ documents.
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path
from typing import Optional


class QmdSetup:
    """Setup and manage qmd collection for context search."""

    DEFAULT_COLLECTION = 'context'

    def __init__(self, context_dir: str, collection: str = None):
        self.context_dir = Path(context_dir).resolve()
        self.collection = collection or self.DEFAULT_COLLECTION

        if not self.context_dir.exists():
            raise ValueError(f"Context directory not found: {context_dir}")

    @staticmethod
    def is_qmd_available() -> bool:
        """Check if qmd is installed."""
        return shutil.which('qmd') is not None

    def collection_exists(self) -> bool:
        """Check if the collection already exists."""
        try:
            result = subprocess.run(
                ['qmd', 'list'],
                capture_output=True,
                text=True,
                timeout=10
            )
            return self.collection in result.stdout
        except Exception:
            return False

    def create_collection(self) -> bool:
        """Create a new qmd collection for the context directory."""
        try:
            # Create collection with context directory as source
            result = subprocess.run(
                [
                    'qmd', 'init',
                    '--collection', self.collection,
                    '--source', str(self.context_dir),
                    '--pattern', '**/*.md'
                ],
                capture_output=True,
                text=True,
                timeout=30
            )

            if result.returncode == 0:
                print(f"✅ Created collection: {self.collection}")
                return True
            else:
                print(f"❌ Failed to create collection: {result.stderr}")
                return False

        except subprocess.TimeoutExpired:
            print("❌ Timeout while creating collection")
            return False
        except Exception as e:
            print(f"❌ Error creating collection: {e}")
            return False

    def update_collection(self) -> bool:
        """Update the collection with current documents."""
        try:
            result = subprocess.run(
                ['qmd', 'update', '--collection', self.collection],
                capture_output=True,
                text=True,
                timeout=60
            )

            if result.returncode == 0:
                print(f"✅ Updated collection: {self.collection}")
                return True
            else:
                print(f"⚠️ Update warning: {result.stderr}")
                return True  # Non-fatal

        except Exception as e:
            print(f"⚠️ Update warning: {e}")
            return True  # Non-fatal

    def embed_documents(self) -> bool:
        """Generate embeddings for all documents."""
        try:
            print("🔄 Generating embeddings (this may take a moment)...")

            result = subprocess.run(
                ['qmd', 'embed', '--collection', self.collection],
                capture_output=True,
                text=True,
                timeout=300  # 5 minutes for large collections
            )

            if result.returncode == 0:
                print(f"✅ Embeddings generated for collection: {self.collection}")
                return True
            else:
                print(f"❌ Failed to generate embeddings: {result.stderr}")
                return False

        except subprocess.TimeoutExpired:
            print("❌ Timeout while generating embeddings")
            return False
        except Exception as e:
            print(f"❌ Error generating embeddings: {e}")
            return False

    def get_status(self) -> Optional[dict]:
        """Get collection status."""
        try:
            result = subprocess.run(
                ['qmd', 'status', '--collection', self.collection, '--json'],
                capture_output=True,
                text=True,
                timeout=10
            )

            if result.returncode == 0:
                return json.loads(result.stdout)
            return None

        except Exception:
            return None

    def setup(self, force: bool = False) -> bool:
        """
        Complete setup process for qmd collection.

        Args:
            force: If True, recreate collection even if it exists

        Returns:
            True if setup was successful
        """
        print(f"\n🔧 Setting up qmd collection: {self.collection}")
        print(f"   Source: {self.context_dir}\n")

        # Check if qmd is available
        if not self.is_qmd_available():
            print("❌ qmd is not installed or not in PATH")
            print("\nTo install qmd, visit: https://github.com/qmd-project/qmd")
            print("Or install via: pip install qmd")
            return False

        # Check if collection exists
        if self.collection_exists() and not force:
            print(f"ℹ️  Collection '{self.collection}' already exists")
            print("   Use --force to recreate")

            # Just update and re-embed
            self.update_collection()
            self.embed_documents()
            return True

        # Create collection
        if not self.create_collection():
            return False

        # Update with current documents
        if not self.update_collection():
            return False

        # Generate embeddings
        if not self.embed_documents():
            return False

        # Show status
        status = self.get_status()
        if status:
            print(f"\n📊 Collection Status:")
            print(f"   Documents: {status.get('document_count', 'N/A')}")
            print(f"   Embedded: {status.get('embedded_count', 'N/A')}")

        print("\n✨ qmd setup complete!")
        print(f"\nTest with: qmd query 'your search query' --collection {self.collection}")

        return True


def main():
    parser = argparse.ArgumentParser(
        description='Setup qmd collection for context semantic search'
    )
    parser.add_argument(
        '--context-dir',
        required=True,
        help='Path to .context directory'
    )
    parser.add_argument(
        '--collection',
        default='context',
        help='Name for the qmd collection (default: context)'
    )
    parser.add_argument(
        '--force',
        action='store_true',
        help='Force recreate collection even if it exists'
    )
    parser.add_argument(
        '--status',
        action='store_true',
        help='Show collection status only'
    )

    args = parser.parse_args()

    try:
        setup = QmdSetup(args.context_dir, args.collection)

        if args.status:
            if not setup.is_qmd_available():
                print("❌ qmd is not available")
                sys.exit(1)

            if not setup.collection_exists():
                print(f"❌ Collection '{args.collection}' does not exist")
                print(f"\nRun without --status to create it")
                sys.exit(1)

            status = setup.get_status()
            if status:
                print(json.dumps(status, indent=2))
            else:
                print("❌ Could not get collection status")
                sys.exit(1)
        else:
            success = setup.setup(force=args.force)
            sys.exit(0 if success else 1)

    except ValueError as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
