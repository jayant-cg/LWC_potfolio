import { LightningElement, wire, track } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getPortfolioAccount from '@salesforce/apex/PortfolioController.getPortfolioAccount';
import upsertPortfolioAccount from '@salesforce/apex/PortfolioController.upsertPortfolioAccount';

export default class Portfolio extends LightningElement {
    account;
    error;
    _wiredResult;

    @track isEditing = false;
    @track isSaving = false;
    @track saveError;
    @track formData = {};

    @wire(getPortfolioAccount)
    wiredAccount(result) {
        this._wiredResult = result;
        const { error, data } = result;
        if (data) {
            this.account = data;
            this.error = undefined;
        } else if (error) {
            this.error = this.reduceError(error);
            this.account = undefined;
        }
    }

    // ── Getters ──────────────────────────────────────────────────────────────

    get hasAccount() {
        return this.account != null;
    }

    get showEmptyState() {
        return !this.hasAccount && !this.error;
    }

    get skills() {
        if (!this.account || !this.account.Skills__c) return [];
        return this.account.Skills__c
            .split(',')
            .map((s) => s.trim())
            .filter((s) => s.length > 0)
            .map((s, i) => ({ label: s, key: i }));
    }

    get emailLink() {
        return this.account?.Email__c ? `mailto:${this.account.Email__c}` : '';
    }

    get editButtonLabel() {
        return this.hasAccount ? 'Edit Details' : 'Add Details';
    }

    get editModalTitle() {
        return this.hasAccount ? 'Edit Portfolio Details' : 'Add Portfolio Details';
    }

    get saveButtonLabel() {
        return this.isSaving ? 'Saving...' : 'Save';
    }

    // ── Handlers ─────────────────────────────────────────────────────────────

    handleEdit() {
        this.formData = {
            name:              this.account?.Name                  ?? '',
            professionalTitle: this.account?.Professional_Title__c ?? '',
            description:       this.account?.Description           ?? '',
            skills:            this.account?.Skills__c             ?? '',
            email:             this.account?.Email__c              ?? '',
            phone:             this.account?.Phone                 ?? '',
            website:           this.account?.Website               ?? '',
            linkedInUrl:       this.account?.LinkedIn_URL__c       ?? '',
            gitHubUrl:         this.account?.GitHub_URL__c         ?? '',
            photoUrl:          this.account?.Photo_URL__c          ?? ''
        };
        this.saveError = undefined;
        this.isEditing = true;
    }

    handleCancel() {
        this.isEditing = false;
        this.saveError = undefined;
    }

    handleFieldChange(event) {
        const field = event.target.dataset.field;
        this.formData = { ...this.formData, [field]: event.target.value };
    }

    async handleSave() {
        if (!this.formData.name || !this.formData.name.trim()) {
            this.saveError = 'Full Name is required.';
            return;
        }

        this.isSaving = true;
        this.saveError = undefined;

        try {
            await upsertPortfolioAccount({
                name:              this.formData.name.trim(),
                professionalTitle: this.formData.professionalTitle || null,
                description:       this.formData.description       || null,
                skills:            this.formData.skills            || null,
                email:             this.formData.email             || null,
                phone:             this.formData.phone             || null,
                website:           this.formData.website           || null,
                linkedInUrl:       this.formData.linkedInUrl       || null,
                gitHubUrl:         this.formData.gitHubUrl         || null,
                photoUrl:          this.formData.photoUrl          || null
            });
            await refreshApex(this._wiredResult);
            this.isEditing = false;
        } catch (err) {
            this.saveError = this.reduceError(err);
        } finally {
            this.isSaving = false;
        }
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    reduceError(error) {
        if (Array.isArray(error.body)) {
            return error.body.map((e) => e.message).join(', ');
        }
        if (error.body && typeof error.body.message === 'string') {
            return error.body.message;
        }
        return error.message ?? 'An unexpected error occurred.';
    }
}
