import { Injectable } from '@angular/core';

import {
    createClient,
    SupabaseClient
} from "@supabase/supabase-js";
import { supabaseConfig } from '../../app-config';

@Injectable({providedIn: 'root'})
export class SupabaseService {

    private _supabase: SupabaseClient;

    constructor() { 
        this._supabase = createClient(
            supabaseConfig.supabaseUrl,
            supabaseConfig.supabaseKey,
        );
    }

    get supabase(): SupabaseClient {
        return this._supabase;
    }
    
    public async signIn(email: string, password: string) {
        const { data, error } = await this.supabase.auth.signInWithPassword({
            email: email,
            password: password,
        });
    }
}