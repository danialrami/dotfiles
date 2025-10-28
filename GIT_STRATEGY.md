# Git Branch Strategy

## Current Situation

### Branches
- `klaxon` (local, on this machine) - Contains all unified multi-platform changes
- `main` (remote) - Original base, needs updates
- `siku` (remote) - Arch Linux specific, now integrated into unified system

### Changes Made
- Environment detection system
- Modular config architecture
- Unified backup/restore scripts
- Comprehensive tests (34 passing)
- Complete Arch starship config

## Strategy: Unify to Main Branch

### Goal
Single `main` branch that:
- Contains all multi-platform support
- Works on macOS (klaxon) and Arch Linux (siku)
- Easily extensible to other platforms

### Rationale
- **Maintenance**: One source of truth instead of branch-per-machine
- **Scalability**: Easy to add new platforms
- **Testing**: All changes in one place for comprehensive testing
- **History**: Cleaner git history

### Execution Plan

#### Step 1: Merge klaxon to main
Push current unified changes to `main`:
```bash
git checkout main
git merge klaxon --no-ff -m "Unify dotfiles for multi-platform support"
git push origin main
```

#### Step 2: Cherry-pick Arch-specific changes (if any)
Any Arch-only changes from `siku` that aren't already integrated:
- neovim config tweaks (minor)
- Any other Arch-specific needs

Already handled:
- ✅ Arch starship config
- ✅ Arch lock files
- ✅ go_env_arch.fish

#### Step 3: Update remote tracking
After merging, klaxon should track main:
```bash
git checkout klaxon
git branch -u origin/main
```

#### Step 4: Archive old branches
After verification, mark old branches as archived:
```bash
git tag archive/siku origin/siku  # Archive siku branch
git push origin archive/siku       # Push tag
# Don't delete - keep for reference
```

## Branch Status After Unification

| Branch | Purpose | Status |
|--------|---------|--------|
| main | Primary development | ✅ Active (all platforms) |
| klaxon | Local tracking | → Merged into main |
| siku | Archive | → Tagged as archive |
| feature/* | Feature branches | → For new work |

## Future Workflow

### Adding New Features
```bash
git checkout main
git pull
git checkout -b feature/my-feature
# Make changes
git push origin feature/my-feature
# Create PR if using GitHub
```

### Per-Machine Updates
```bash
# Always pull from main
git pull origin main

# Changes automatically adapt via detect-env.sh
python3 backup-dotfiles.py
```

### For New Machines
```bash
git clone https://github.com/yourusername/dotfiles ~/.dotfiles
cd ~/.dotfiles
python3 restore-dotfiles.py
# Automatically uses correct configs for platform
```

## Deployment

### macOS (klaxon)
```bash
git pull origin main
python3 restore-dotfiles.py
```

### Arch Linux (siku)
```bash
git pull origin main
python3 restore-dotfiles.py
```

## Safety Measures

✅ All changes already in klaxon branch  
✅ 34 comprehensive tests passing  
✅ Environment detection verified  
✅ Arch starship config complete  
✅ Backup scripts updated  
✅ Documentation comprehensive  

Before merging to main:
- [ ] Run all tests again
- [ ] Verify no uncommitted changes
- [ ] Ensure remote is up to date
- [ ] Tag current main as backup (optional)

## Rollback Plan

If needed:
```bash
# Reset to before merge
git reset --hard <commit-before-merge>
git push origin main --force-with-lease
```

But unlikely needed given:
- Tests verify all functionality
- Backward compatible
- Original code still available in git history

---

**Status**: Ready to execute  
**Target**: Unified main branch supporting macOS and Arch Linux
